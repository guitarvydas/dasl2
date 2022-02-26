(defparameter $no nil)
(defparameter $yes t)

(defun $get-kv ($context field-symbol)
  (assoc field-symbol $context))

(defun $get-field ($context field-symbol)
  (let ((kv ($get-kv $context field-symbol)))
    (when kv
      (cdr kv))))
            
(defun $get-field-recursive ($context field-symbol)
  (cond
   ((not (null $context))
    (let ((v ($get-kv $context field-symbol)))
      (cond
       (v (cdr v))
       (t
        (let ((parent-pair ($get-kv $context 'container)))
          (cond
           ((null parent-pair) nil)
           (t ($get-field-recursive (cdr parent-pair) field-symbol)))))))) ;; find field recursively in parent
   (t nil)))

(defun $maybe-set-field ($context field-symbol v)
  (cond
   ((null ($get-kv $context field-symbol))
    `( (,field-symbol . ,v) ,@$context))
   (t
    (setf (cdr ($get-kv $context field-symbol)) v)
    $context)))

;;; mutation - queues only
(defun enqueue-input (context message)
  (let ((newq (append (cdr ($get-kv context 'input-queue)) (list message))))
    (let ((oldassoc ($get-kv context 'input-queue)))
      (setf (cdr oldassoc) newq))))

(defun enqueue-output (context message)
  (let ((newq (append ($get-kv context 'output-queue) (list message))))
    (let ((oldassoc ($get-kv context 'output-queue)))
      (setf (cdr oldassoc) newq))))

(defun dequeue-input (context)
  (when ($get-kv context 'input-queue)
    (let ((q ($get-field context 'input-queue)))
      (pop q))))

(defun $get-input-queue (context)
  ($get-kv context 'input-queue))

(defun $non-empty-input-queue? (context)
  (not (null ($get-input-queue context))))
;;;


(defun $dispatch-initially ($context)
  (let ((initially-function ($get-field $context 'initially)))
    (when initially-function
      (funcall initially-function $context))))

(defun $dispatch-finally ($context)
  (let ((finally-function ($get-field $context 'finally)))
    (when finally-function
      (funcall finally-function $context))))

(defun $dispatch ($context)
  ($dispatch-initially $context)
  ($dispatch-concurrently $context)
  ($dispatch-finally $context))

(defparameter *done* nil)
(defun $dispatch-conclude ($context)
  (declare (ignore $context))
  (setf *done* t))
(defun $dispatch-continue? ($context)
  (declare (ignore $context))
  (not *done*))

(defun $dispatch-concurrently ($context)
  (loop
    while ($dispatch-continue? $context)
    do (progn
	 (format *standard-output* "dispatch-concurrently (a)~%")
	 (dump $context 0)
	 (try-all-components-once $context)
	 (format *standard-output* "dispatch-concurrently (b)~%")
	 (dump $context 0)
         (car '(debug))
	 )))

(defun try-all-components-once ($context)
  (try-component $context))

;; per Drakon diagram
(defun try-component ($context)
  (cond
    ((has-children? $context)
     (try-each-child $context)
     (cond
       ((child-produced-output? $context) (produced-output))
       (t 
	(try-self $context)
	(cond
	  ((self-produced-output? $context) (produced-output))
	  (t (no-output))))))
    (t (try-self $context))))

(defun no-output () 'no-output)
(defun produced-output () 'output)
(defun has-children? ($context) (not (null ($get-field $context 'children))))
(defun child-produced-output? ($context)
  ;; ok to check $self, since it hasn't been run yet and, therefore has no outputs
  (produced-output? ($get-field $context 'children)))
(defun self-produced-output? ($context)
  (produced-output? (list (get-self-context $context))))

(defun produced-output? (children)
  (cond
    ((null children) nil)
    ((not (output-queue-empty? (car children))) t)
    (t (produced-output? (cdr children)))))

(defun output-queue-empty? ($context)
  (null ($get-field $context 'output-queue)))
(defun get-self-context ($context)
  $context)

(defun try-each-child ($context)
;; must not invoke $self
  (cond
    ((leaf? $context) (try-leaf $context))
    (t (mapc #'(lambda (pair)
                 (unless (is-self-name? (first pair))
                   (try-component (cdr pair))))
             ($get-field $context 'children)))))

(defun try-self ($context)
  (cond
    ((leaf? $context) (try-leaf $context))
    (t (try-container $context))))
(defun try-leaf ($context)
  (let (($message (dequeue-input $context)))
    (when $message
      (let ((handler ($get-field $context 'handler)))
	(unless handler (error-missing-handler $context $message)) ;; if fail => missing handler, yet there are messages <==> can't happen
	(funcall handler $context $message)))))

(defun try-container ($context)
  (let (($message (dequeue-input $context)))
    (when $message
      (let ((handler ($get-field $context 'handler)))
	(when handler (error-container-cannot-have-handler $context $message)) ;; if fail => handler not allowed for Container, must always use default handler
	(let ((port (new-port (get-self) (get-etag-from-message $message))))
	  (let ((connection (find-connection-by-sender port (get-connections $context))))
            (let ((previous-message $message))
	      (queue-input-foreach-receiver (get-receivers-from-connection connection) (get-data-from-message $message) $context previous-message))))))))

(defun get-self () "$self")

(defun queue-input-foreach-receiver (receivers data $context previous-message)
  (when receivers
    (let ((receiver (first receivers)))
      (let ((etag (get-etag-from-receiver receiver))
            (target-component-name (get-component-from-receiver receiver)))
	(let ((message (new-message etag data previous-message)))
	  (enqueue-message receiver message target-component-name $context)
	  (queue-input-foreach-receiver (cdr receivers) data $context previous-message))))))


(defun find-connection-by-sender (port connection-list)
  (cond
    ((null connection-list)
     (error-cannot-find-sender port connection-list))
    ( t
      (cond ((port-same? port (get-sender-port (car connection-list)))
	     connection-list)
	    (t (find-connection-by-sender port (cdr connection-list)))))))

(defun get-sender-port (connection)
  (car connection))

(defun port-same? (portA portB)
  (and
   (string= (get-component-of-port portA) (get-component-of-port portB))
   (string= (get-etag-of-port portA) (get-etag-of-port portB))))

(defun get-component-of-port (p)
  (first p))

(defun get-etag-of-port (p)
  (cdr p))

(defun get-etag-from-receiver (r)
  (get-etag-of-port r))

(defun route-children-outputs (container-context children-name-context-pairs)
  ;; move all outputs from children to other children (or to self's output)
  ;; remap etags along the way (in general an output etag will not be the same as a target's etag, and, a target's etag will not be the same as another target's etag)
  (cond
    ((null children-name-context-pairs) nil)
    (t (let ((child-name-context (first children-name-context-pairs)))
	 (route-child-outputs container-context (get-child-context child-name-context))
	 (route-children-outputs container-context (cdr children-name-context-pairs))))))


(defun route-child-outputs (container-context child-name-context-pair)
  (let ((child-name (get-child-name child-name-context-pair))
	(child-context (get-child-context child-name-context-pair)))
    (route-child-outputs-recursively container-context
                                     child-name
                                     ($get-field child-context 'output-queue))))
  
(defun route-child-outputs-recursively (container-context child-name output-messages)
  (cond
    ((null output-messages) nil)
    (t (let ((output-message (car output-messages)))
	 (route-message container-context output-message child-name)))))

(defun route-message (container-context message component-name)
  (let ((connection-map ($get-field container-context 'connections)))
    (let ((etag (get-etag-from-message message)))
      (let ((connection (find-connection-by-sender (new-port component-name etag) connection-map)))
        (let ((receivers (get-receivers-from-connection connection)))
          (foreach receiver in receivers
                   do (route-single-message receiver message container-context)))))))

(defun route-single-message (receiver message container-context)
  (let ((target-component-name (get-component-from-receiver receiver)))
    (let ((etag (get-etag-from-message message)))
      (let ((m (new-message etag (get-data-from-message message) message)))
        (enqueue-message receiver m target-component-name container-context)))))

(defun enqueue-message (receiver message target-component-name container-context)
(format *standard-output* "enqueuing ~a ~a~%" message target-component-name)
  (let ((target-context (get-context-from-name target-component-name container-context)))
    (let ((direction (determine-port-direction receiver target-context)))
      (cond
       ((eq 'input direction) (enqueue-input target-context message))
       (t      (enqueue-output target-context message))))))
    
(defun new-message (etag data previous-message)
  ;; etag data (trace ...)
  (cons etag (cons data (cons previous-message (third previous-message)))))

      
(defun get-etag-from-message (message)
  (first message))

(defun get-data-from-message (message)
  (cdr message))

(defun new-port (component-name etag)
  (cons component-name etag))

(defun get-receivers-from-connection (connection)
  (cdr connection))

(defun error-cannot-find-sender (port connection-list)
  (format *error-output* "internal error: can't find port ~a in connection list ~a~%" port connection-list)
  (assert nil))

(defun error-send (context message)
  (format *error-output* "send message=~a invoked on component with no container ~a~%" message context)
  (assert nil))

(defun error-unhandled-message (context message)
  (format *error-output* "unhandled message=~a for component ~a~%" message context)
  (assert nil))

(defun error-cannot-find-child ($context child-name)
  (format *error-output* "internal error: can't find child ~a in context ~a~%" child-name $context)
  (assert nil))

(defun error-cannot-find-prototype (prototype-name)
  (format *error-output* "internal error: can't find prototype ~a~%" prototype-name)
  (assert nil))

(defun error-cannot-determine-port-direction (port component-context)
  (format *error-output* "internal error: can't determine port direction ~a in ~a~%" port component-context)
  (assert nil))

(defun error-missing-handler ($context $message)
  (format *error-output* "internal error: no handler for message ~a in ~a~%" $message $context)
  (assert nil))

(defun error-container-cannot-have-handler ($context $message)
;; if fail => handler not allowed for Container, must always use default handler
  (format *error-output* "internal error: container overspecified with handler for message ~a in ~a~%" $message $context)
  (assert nil))


(defun lookup-child ($context child-name)
  (lookup-child-recursive $context ($get-field $context 'children) child-name))

(defun lookup-child-recursive ($context children-list child-name)
  (cond
   ((null children-list) (error-cannot-find-child $context child-name))
   ((string= child-name (get-local-child-name (first children-list)))
    (get-local-child-context (first children-list)))
   (t (lookup-child-recursive $context (rest children-list) child-name))))

(defun get-local-child-name (pair)
  (first pair))
(defun get-local-child-context (pair)
  (cdr pair))



(defun instantiate (prototype parent prototype-bag)
  (let ((self `((prototype . ,prototype)
		,(cons 'children nil)
		(locals . ,(instantiate-locals ($get-field prototype 'locals)))
		,(cons 'input-queue nil)
		,(cons 'output-queue nil)
		(container . ,parent)
		,@(clone-prototype prototype))))
    ($maybe-set-field self 'children (instantiate-children prototype-bag self ($get-field prototype 'children)))))

(defun instantiate-children (prototype-bag parent children)
  (cond 
    ((null children) nil)
    (t (cons 
	(instantiate-child prototype-bag parent (car children))
	(instantiate-children prototype-bag parent (cdr children))))))

(defun clone-prototype (p)
  (cond
    ((null p) nil)
    (t 
     (cons (car p) (clone-prototype (cdr p))))))

(defun instantiate-child (prototype-bag parent child-pair)
  (let ((name (first child-pair))
	(prototype-name (cdr child-pair)))
    (cond
      ((is-self-name? name) (let ((self parent))
			      (cons name self)))
      (t (cons name
	       (instantiate (fetch-prototype-by-name prototype-name prototype-bag)
			    parent
			    prototype-bag))))))

(defun instantiate-locals (locals)
  (cond
   ((null locals) nil)
   (t (cons (instantiate-local (car locals))
            (instantiate-locals (cdr locals))))))

(defun instantiate-local (pair)
  (let ((name (car pair)))
    (cons name nil))) ;; fresh list for each local, initialized to NIL

(defun fetch-prototype-by-name (prototype-name prototype-bag)
  (cond 
    ((null prototype-bag) (error-cannot-find-prototype prototype-name))
    ((string= prototype-name ($get-field (car prototype-bag) 'name))
     (car prototype-bag))
    (t (fetch-prototype-by-name prototype-name (cdr prototype-bag)))))

(defun determine-port-direction (receiver component-context)
  (cond
    ((input? receiver (prototype-of component-context)) 'input)
    ((output? receiver (prototype-of component-context)) 'output)
    (t (error-cannot-determine-port-direction receiver component-context))))

(defun prototype-of (context)
  ($get-field context 'prototype))

(defun input? (port prototype)
  (member (get-etag-of-port port) ($get-field prototype 'inputs)))

(defun output? (port prototype)
  (member (get-etag-of-port port) ($get-field prototype 'outputs)))

(defun get-context-from-name (name container-context)
  (get-context-from-children-by-name name ($get-field container-context 'children) container-context))

(defun get-context-from-children-by-name (name children container-context)
  (cond 
    ((null children) (error-cannot-find-child container-context name))
    ((string= name (get-child-name (car children)))
     (get-child-context (car children)))
    (t (get-context-from-children-by-name name (cdr children) container-context))))

(defun get-component-from-receiver (receiver-port)
  (first receiver-port))

(defun leaf? ($context)
  (null ($get-field $context 'children)))
  
(defun has-outputs? ($context)
  (not (null ($get-field $context 'output-queue))))


(defun $send (sender-port v container-context debug)
  (let ((sender-name (car sender-port)))
    (let ((child-context (lookup-child container-context sender-name)))
      (enqueue-output child-context (new-output-message sender-port v debug)))))

(defun new-output-message (sender-port v debug)
  `(,sender-port ,v ,debug))

(defun $inject (receiver-port v container-context debug)
  (assert v)
  (let ((receiver-name (get-component-from-receiver receiver-port))
        (receiver-etag (get-etag-from-receiver receiver-port)))
    (let ((child-context (lookup-child container-context receiver-name)))
      (enqueue-input child-context (new-message receiver-etag v debug)))))

(defun get-child-name (name-context-pair)
  (car name-context-pair))
(defun get-child-context (name-context-pair)
  (cdr name-context-pair))

(defun get-connections ($context)
  ($get-field $context 'connections))

(defun is-self-name? (name)
  (string= "$self" name))

(defun dump ($context depth)
  ;; for debugging at early stages
  (mapc #'(lambda (pair)
            (unless (is-self-name? (get-child-name pair))
              (dump (get-child-context pair) (+ 2 depth))))
	($get-field $context 'children))
  (dump-queues $context depth))

(defun spaces (depth)
  (cond
    ((zerop depth) nil)
    (t 
     (format *standard-output* " ")
     (spaces (1- depth)))))
  
(defun dump-queues ($context depth)
  (spaces depth)
  (format *standard-output* "name=~s " ($get-field $context 'name))
  (spaces depth)
  (format *standard-output* "inq=~s " ($get-field $context 'input-queue))
  (spaces depth)
  (format *standard-output* "outq=~s~%" ($get-field $context 'output-queue)))
