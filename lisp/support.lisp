(defparameter $no nil)
(defparameter $yes t)

(defun $get-field ($context field-symbol)
  (let ((v (assoc field-symbol $context)))
    (cond
     (v (cdr v))
     ((null ($get-field $context 'ancestor))
      nil)
     (t ($get-field ($get-field $context 'ancestor) field-symbol))))) ;; find field recursively in parent

(defun $maybe-set-field ($context field-symbol v)
  (cond
   ((null ($get-field $context field-symbol))
    `( (,field-symbol . ,v) ,@$context))
   (t
    (setf (cdr ($get-field $context field-symbol)) v))))

;;; mutation - queues only
(defun enqueue-input (context message)
  (let ((newq (append ($get-field context 'input-queue) (list message))))
    (let ((oldassoc (assoc 'input-queue context)))
      (setf (cdr oldassoc) newq))))

(defun enqueue-output (context message)
  (let ((newq (append ($get-field context 'output-queue) (list message))))
    (let ((oldassoc (assoc 'output-queue context)))
      (setf (cdr oldassoc) newq))))

(defun dequeue-input (context)
  (when ($get-field context 'input-queue)
    (let ((q ($get-field context 'input-queue)))
      (pop q))))
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

(defun $dispatch-concurrently ($context &rest args)
  (declare (ignore args))
  (loop
    while ($dispatch-continue? $context)
    do (progn
	 (format *standard-output* "dispatch-concurrently a~%")
	 (dump $context 0)
	 (run-once $context)
	 (format *standard-output* "dispatch-concurrently b~%")
	 (dump $context 0)
         (car '(debug))
	 )))

(defun run-once ($context)
  (let ((children-pairs ($get-field $context 'children)))
    (let ((list-had-outputs (dispatch-each-child children-pairs)))
      (let ((any-child-outputs? (any-child-had-outputs? list-had-outputs)))
        (cond 
         (any-child-outputs?
          (route-child-outputs $context children-pairs)
          t)
         ((leaf? $context)
          (dispatch-leaf $context)
          (has-outputs? $context))
         (t
          ;; attempt container dispatch only if all children are quiescent
          (dispatch-container $context)))))))


(defun any-child-had-outputs? (booleans)
  (and booleans))

(defun dispatch-each-child (children-name-context-pairs)
  ;; return list of booleans, t if child produced output
  (mapcar #'(lambda (name-context-pair)
              (let ((child-context (get-child-context name-context-pair)))
                (run-once child-context)))
          children-name-context-pairs))

(defun dispatch-leaf (context)
  (let ((handler ($get-field context 'handler)))
    (let ((q ($get-field context 'input-queue)))
      (when (and q handler)
	(let ((message (dequeue-input q)))
	  (funcall handler context message))))))

(defun dispatch-container (container-context)
  ;; return t if container moved any input to any child or any of its own outputs
  ;; i.e. t => container consumed one input and activated a child, or, produced an output
  ;; i.e. nil => container has no inputs, or, container dequeued an input and discarded it
  ;; thought: maybe there can be connections to "pass" so that messages can be dropped explicitly instead of implicitly? 
  (let ((q ($get-field container-context 'input-queue)))
    (cond
      ((not (null q))
       (let ((message (dequeue-input q)))
         (let ((connection-map ($get-field container-context 'connections))) 
           (let ((connection (find-connection-by-sender (new-port ($get-field container-context 'name)
                                                                  (get-etag-from-message message))
                                                        connection-map)))
             (let ((receivers (get-receivers-from-connection connection)))
               (foreach port in receivers
                        do (route-single-message port message container-context))
               t)))))
      (t nil))))

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
  (format *error-output* "send message=~a invoked on component with no ancestor ~a~%" message context)
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
  `((prototype . ,prototype)
    (children . ,(instantiate-children prototype-bag parent ($get-field prototype 'children)))
    (locals . ,(instantiate-locals ($get-field prototype 'locals)))
    (input-queue . nil)
    (output-queue . nil)
    (ancestor . ,parent)
    ,@(copy-prototype prototype)))

(defun instantiate-children (prototype-bag parent children)
  (cond 
    ((null children) nil)
    (t (cons 
	(instantiate-child prototype-bag parent (car children))
	(instantiate-children prototype-bag parent (cdr children))))))

(defun copy-prototype (p)
  (cond
    ((null p) nil)
    (t 
     (cons (car p) (copy-prototype (cdr p))))))

(defun instantiate-child (prototype-bag parent child-pair)
  (let ((name (first child-pair))
	(prototype-name (cdr child-pair)))
    (cons
     name
     (instantiate (fetch-prototype-by-name prototype-name prototype-bag)
		  parent
		  prototype-bag))))

(defun instantiate-locals (locals)
  (cond
   ((null locals) nil)
   (t (cons (instantiate-local (car locals))
            (instantiate-locals (cdr locals))))))

(defun instantiate-local (pair)
  (let ((name (car pair)))
    (cons name nil))) ;; fresh list for each local, initialized to NIL

(defun fetch-prototype-by-name (prototype-name prototype-bag)
  (when prototype-name ;; protype-name is NIL for $self
    (cond 
     ((null prototype-bag) (error-cannot-find-prototype prototype-name))
     ((string= prototype-name ($get-field (car prototype-bag) 'name))
      (car prototype-bag))
     (t (fetch-prototype-by-name prototype-name (cdr prototype-bag))))))

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
  (let ((receiver-name (car receiver-port)))
    (let ((child-context (lookup-child container-context receiver-name)))
      (enqueue-input child-context (new-message receiver-port v debug)))))

(defun get-child-name (name-context-pair)
  (car name-context-pair))
(defun get-child-context (name-context-pair)
  (cdr name-context-pair))

(defun dump ($context depth)
  ;; for debugging at early stages
  (mapc #'(lambda (pair)
	    (dump (get-child-context pair) (+ 2 depth)))
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
