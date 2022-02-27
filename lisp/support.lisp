(defparameter $no nil)
(defparameter $yes t)

(defun $?kv ($context field-symbol)
  (assoc field-symbol $context))

(defun $?field ($context field-symbol)
  (syn kv ($?kv $context field-symbol)
       (when kv
	 (cdr kv))))
            
(defun $?field-recursive ($context field-symbol)
  (cond
   ((not (null $context))
    (let ((v ($?kv $context field-symbol)))
      (cond
       (v (cdr v))
       (t
        (let ((parent-pair ($?kv $context 'container)))
          (cond
           ((null parent-pair) nil)
           (t ($?field-recursive (cdr parent-pair) field-symbol)))))))) ;; find field recursively in parent
   (t nil)))

(defun $maybe-set-field ($context field-symbol v)
  (cond
   ((null ($?kv $context field-symbol))
    `( (,field-symbol . ,v) ,@$context))
   (t
    (setf (cdr ($?kv $context field-symbol)) v)
    $context)))

(defun $set-field ($context field-symbol v)
  (cond
   ((null ($?kv $context field-symbol)) (assert nil)) ;; $set-field should only be called when we know that field-symbol is already in the context
   (t ($maybe-set-field $context field-symbol v))))

;;; mutation - queues only
(defun enqueue-input (context message)
  (syn newq (append (cdr ($?kv context 'input-queue)) (list message))
    (syn oldassoc ($?kv context 'input-queue)
	 (setf (cdr oldassoc) newq))))

(defun enqueue-output (context message)
  (syn newq (append (cdr ($?kv context 'output-queue)) (list message))
       (syn oldassoc ($?kv context 'output-queue)
	    (setf (cdr oldassoc) newq))))

(defun dequeue-input (context)
  (syn kv ($?kv context 'input-queue)
       (when kv
	 (pop (cdr kv)))))

(defun $?input-queue (context)
  ($?kv context 'input-queue))

(defun $non-empty-input-queue? (context)
  (not (null ($?input-queue context))))
;;;


(defun $dispatch-initially ($context)
  (syn initially-function ($?field $context 'initially)
       (when initially-function
	 (funcall initially-function $context))))

(defun $dispatch-finally ($context)
  (syn finally-function ($?field $context 'finally)
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
	 (try-all-components-once $context)
	 )))

(defun try-all-components-once ($context)
  (try-component $context))

(defun try-component ($context)
  (try-component-without-routing $context)
  (route-children-outputs $context ($?field $context 'children)))

;; per Drakon diagram
;; recursively run each child, if any child produced output, don't run parent
(defun try-component-without-routing ($context)
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

(defun no-output () nil)
(defun produced-output () t)
(defun has-children? ($context) (not (null ($?field $context 'children))))
(defun child-produced-output? ($context)
  ;; ok to check $self, since it hasn't been run yet and, therefore has no outputs
  (produced-output? ($?field $context 'children)))
(defun self-produced-output? ($context)
  (produced-output? (list (?self-context $context))))

(defun produced-output? (children)
  (cond
    ((null children) nil)
    ((not (output-queue-empty? (?local-child-context (car children)))) t)
    (t (produced-output? (cdr children)))))

(defun output-queue-empty? ($context)
  (null ($?field $context 'output-queue)))
(defun ?self-context ($context)
  $context)

(defun try-each-child ($context)
;; must not invoke $self
  (cond
    ((leaf? $context) (try-leaf $context))
    (t (mapc #'(lambda (pair)
                 (unless (is-self-name? (first pair))
                   (try-component (cdr pair))))
             ($?field $context 'children)))))

(defun try-self ($context)
  (cond
    ((leaf? $context) (try-leaf $context))
    (t (try-container $context))))

(defun try-leaf ($context)
  (syn $message (dequeue-input $context)
       (when $message
	 (syn handler ($?field $context 'handler)
	      (unless handler (error-missing-handler $context $message)) ;; if fail => missing handler, yet there are messages <==> can't happen
	      (funcall handler $context $message)))))

(defun try-container ($context)
  (syn $message (dequeue-input $context)
    (when $message
      (syn handler ($?field $context 'handler)
	   (when handler (error-container-cannot-have-handler $context $message)) ;; if fail => handler not allowed for Container, must always use default handler
	   (syn port (new-port (?self) (?etag-from-message $message))
		(syn connection (find-connection-by-sender port (?connections $context))
            (syn previous-message $message
		 (queue-input-foreach-receiver (?receivers-from-connection connection) (?data-from-message $message) $context previous-message))))))))

(defun ?self () "$self")

(defun queue-input-foreach-receiver (receivers data $context previous-message)
  (when receivers
    (syn receiver (first receivers)
	 (syn etag (?etag-from-receiver receiver)
              (syn target-component-name (?component-from-receiver receiver)
		   (syn message (new-message (new-port target-component-name etag) data previous-message)
			(enqueue-message receiver message target-component-name $context)
			(queue-input-foreach-receiver (cdr receivers) data $context previous-message)))))))


(defun find-connection-by-sender (port connection-list)
  (cond
    ((null connection-list)
     (error-cannot-find-sender port connection-list))
    ( t
      (cond ((port-same? port (?sender-port (car connection-list)))
	     (car connection-list))
	    (t (find-connection-by-sender port (cdr connection-list)))))))

(defun ?sender-port (connection)
  (car connection))

(defun port-same? (portA portB)
  (and
   (string= (?component-of-port portA) (?component-of-port portB))
   (string= (?etag-from-port portA) (?etag-from-port portB))))

(defun ?component-of-port (p)
  (first p))

(defun ?etag-from-port (p)
  (cdr p))

(defun ?etag-from-receiver (r)
  (?etag-from-port r))

(defun route-children-outputs (container-context children-name-context-pairs)
  ;; move all outputs from children to other children (or to self's output)
  ;; remap etags along the way (in general an output etag will not be the same as a target's etag, and, a target's etag will not be the same as another target's etag)
  (cond
    ((null children-name-context-pairs) nil)
    ((is-self-name? (?child-name (first children-name-context-pairs)))
     (route-children-outputs container-context (cdr children-name-context-pairs)))
    (t (syn child-name-context-pair (first children-name-context-pairs)
            (route-child-outputs container-context child-name-context-pair)
            (route-children-outputs container-context (cdr children-name-context-pairs))))))


(defun route-child-outputs (container-context child-name-context-pair)
  (syn child-name (?child-name child-name-context-pair)
       (syn child-context (?child-context child-name-context-pair)
	    (syn message-list ($?field child-context 'output-queue)
		 ($set-field child-context 'output-queue nil)          
		 (route-child-outputs-recursively container-context child-name message-list)))))
  
(defun route-child-outputs-recursively (container-context child-name output-messages)
  (cond
    ((null output-messages) nil)
    (t (syn output-message (car output-messages)
	    (route-message container-context output-message child-name)))))

(defun route-message (container-context message component-name)
  (syn connection-map ($?field container-context 'connections)
       (syn etag (?etag-from-message message)
	    (syn connection (find-connection-by-sender (new-port component-name etag) connection-map)
		 (syn receivers (?receivers-from-connection connection)
		      (foreach receiver in receivers
			       do (route-single-message receiver message container-context)))))))

(defun route-single-message (receiver message container-context)
  (syn target-component-name (?component-from-receiver receiver)
       (syn etag (?etag-from-message message)
	    (syn m (new-message (new-port target-component-name etag) (?data-from-message message) message)
		 (enqueue-message receiver m target-component-name container-context)))))

(defun enqueue-message (receiver message target-component-name container-context)
  (format *standard-output* "enqueuing ~s ~s~%" message target-component-name)
  (syn target-context (lookup-context-from-name target-component-name container-context)
       (syn direction (determine-port-direction receiver target-context)
	    (cond
	      ((eq 'input direction) (enqueue-input target-context message))
	      (t      (enqueue-output target-context message))))))
    
(defun new-message (port data previous-message)
  ;; etag data (trace ...)
  (assert (listp port))
  (cons port (cons data (cons previous-message (cons (third previous-message) nil)))))

      
(defun ?etag-from-message (message)
  (?etag-from-port (?port-from-message message)))

(defun ?port-from-message (message)
  (car message))

(defun ?data-from-message (message)
  (car (cdr message)))

(defun ?debug-from-message (message)
  (cdr (cdr message)))

(defun new-port (component-name etag)
  (cons component-name etag))

(defun ?receivers-from-connection (connection)
  (cdr connection))

(defun error-cannot-find-sender (port connection-list)
  (format *error-output* "internal error: can't find port ~s in connection list ~s~%" port connection-list)
  (assert nil))

(defun error-send (context message)
  (format *error-output* "send message=~s invoked on component with no container ~s~%" message (name-from-context context))
  (assert nil))

(defun error-unhandled-message (context message)
  (format *error-output* "unhandled message=~s for component ~s~%" message (name-from-context context))
  (assert nil))

(defun error-cannot-find-child ($context child-name)
  (format *error-output* "internal error: can't find child ~s in context ~s~%" child-name (name-from-context $context))
  (assert nil))

(defun error-cannot-find-prototype (prototype-name)
  (format *error-output* "internal error: can't find prototype ~s~%" prototype-name)
  (assert nil))

(defun error-cannot-determine-port-direction (port component-context)
  (format *error-output* "internal error: can't determine port direction ~s in ~s~%" port (name-from-context component-context))
  (assert nil))

(defun error-missing-handler ($context $message)
  (format *error-output* "internal error: no handler for message ~s in ~s~%" $message (name-from-context $context))
  (assert nil))

(defun error-container-cannot-have-handler ($context $message)
;; if fail => handler not allowed for Container, must always use default handler
  (format *error-output* "internal error: container overspecified with handler for message ~s in ~s~%" $message (name-from-context $context))
  (assert nil))

(defun name-from-context ($context)
  ($?field $context 'name))

(defun lookup-child ($context child-name)
  (lookup-child-recursive $context ($?field $context 'children) child-name))

(defun lookup-child-recursive ($context children-list child-name)
  (cond
   ((null children-list) (error-cannot-find-child $context child-name))
   ((string= child-name (?local-child-name (first children-list)))
    (?local-child-context (first children-list)))
   (t (lookup-child-recursive $context (rest children-list) child-name))))

(defun ?local-child-name (pair)
  (first pair))
(defun ?local-child-context (pair)
  (cdr pair))



(defun instantiate (prototype parent prototype-bag)
  (syn self `((prototype . ,prototype)
	      ,(cons 'children nil)
	      (locals . ,(instantiate-locals ($?field prototype 'locals)))
	      ,(cons 'input-queue nil)
	      ,(cons 'output-queue nil)
	      (container . ,parent)
	      ,@(clone-prototype prototype))
       ($maybe-set-field self 'children (instantiate-children prototype-bag self ($?field prototype 'children)))))

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
  (syn name (first child-pair)
       (syn prototype-name (cdr child-pair)
	    (cond
	      ((is-self-name? name) (let ((self parent))
				      (cons name self)))
	      (t (cons name
		       (instantiate (fetch-prototype-by-name prototype-name prototype-bag)
				    parent
				    prototype-bag)))))))

(defun instantiate-locals (locals)
  (cond
   ((null locals) nil)
   (t (cons (instantiate-local (car locals))
            (instantiate-locals (cdr locals))))))

(defun instantiate-local (pair)
  (syn name (car pair)
       (cons name nil))) ;; fresh list for each local, initialized to NIL

(defun fetch-prototype-by-name (prototype-name prototype-bag)
  (cond 
    ((null prototype-bag) (error-cannot-find-prototype prototype-name))
    ((string= prototype-name ($?field (car prototype-bag) 'name))
     (car prototype-bag))
    (t (fetch-prototype-by-name prototype-name (cdr prototype-bag)))))

(defun determine-port-direction (receiver component-context)
  (cond
    ((input? receiver (prototype-of component-context)) 'input)
    ((output? receiver (prototype-of component-context)) 'output)
    (t (error-cannot-determine-port-direction receiver component-context))))

(defun prototype-of (context)
  ($?field context 'prototype))

(defun input? (port prototype)
  (member (?etag-from-port port) ($?field prototype 'inputs)))

(defun output? (port prototype)
  (member (?etag-from-port port) ($?field prototype 'outputs)))

(defun lookup-context-from-name (name container-context)
  (lookup-context-from-children-by-name name ($?field container-context 'children) container-context))

(defun lookup-context-from-children-by-name (name children container-context)
  (cond 
    ((null children) (error-cannot-find-child container-context name))
    ((string= name (?child-name (car children)))
     (?child-context (car children)))
    (t (lookup-context-from-children-by-name name (cdr children) container-context))))

(defun ?component-from-receiver (receiver-port)
  (first receiver-port))

(defun leaf? ($context)
  (null ($?field $context 'children)))
  
(defun has-outputs? ($context)
  (not (null ($?field $context 'output-queue))))


(defun $send (sender-port v component-context debug)
(format *standard-output* "$send ~a ~s~%"  sender-port v)
  (syn container-context ($?field component-context 'container)
       (assert container-context) ;; should not call send from top-level container (whose container is NIL)
       (syn sender-name (car sender-port)
	    (syn child-context (lookup-child container-context sender-name)
		 (enqueue-output child-context (new-output-message sender-port v debug))))))

(defun new-output-message (sender-port v debug)
  (list sender-port v debug))

(defun $inject (receiver-port v container-context debug)
  (assert v)
(format *standard-output* "$inject ~a ~s~%"  receiver-port v)
  (syn receiver-name (?component-from-receiver receiver-port)
       (syn receiver-etag (?etag-from-receiver receiver-port)
	    (syn child-context (lookup-child container-context receiver-name)
		 (enqueue-input child-context (new-message (new-port receiver-name receiver-etag) v debug))))))

(defun ?child-name (name-context-pair)
  (car name-context-pair))
(defun ?child-context (name-context-pair)
  (cdr name-context-pair))

(defun ?connections ($context)
  ($?field $context 'connections))

(defun is-self-name? (name)
  (string= "$self" name))

(defun dump ($context depth)
  ;; for debugging at early stages
  (mapc #'(lambda (pair)
            (unless (is-self-name? (?child-name pair))
              (dump (?child-context pair) (+ 2 depth))))
	($?field $context 'children))
  (dump-queues $context depth))

(defun spaces (depth)
  (cond
    ((zerop depth) nil)
    (t 
     (format *standard-output* " ")
     (spaces (1- depth)))))
  
(defun dump-queues ($context depth)
  (spaces depth)
  (format *standard-output* "name=~s " ($?field $context 'name))
  (spaces depth)
  (format *standard-output* "inq length=~a " (length ($?field $context 'input-queue)))
  (spaces depth)
  (format *standard-output* "outq length=~a~%" (length ($?field $context 'output-queue))))
