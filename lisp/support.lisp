(defun $get-field ($context field-symbol)
  (let ((v (assoc field-symbol $context)))
    (when v
      (cdr v))))      

(defun $set-field ($context field-symbol v)
  (setf (cdr ($get-field $context field-symbol)) v))

(defun $dispatch-initially ($context &rest args)
  (let ((initially-function ($get-field $context 'initially)))
    (when initially-function
      (funcall initially-function $context args))))

(defun $dispatch-finally ($context &rest args)
  (let ((finally-function ($get-field $context 'finally)))
    (when finally-function
      (funcall finally-function $context args))))

(defun $dispatch ($context &rest args)
  ($dispatch-initially $context args)
  ($dispatch-concurrently $context args)
  ($dispatch-finally $context args))

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
    while (continue $context)
    do (run-once $context)))

(defun run-once ($context)
  (let ((children-names ($get-field $context 'children)))
    (let ((children (map-child-names-to-contexts $context children-names)))
      (let ((list-had-outputs (dispatch-each-child children)))
	(let ((any-child-outputs (any-child-had-outputs list-had-outputs)))
	  (cond 
	    (any-child-outputs
	      (route-child-outputs $context children)
	      t)
	    ((leaf? $context)
	     (dispatch-leaf $context)
	     (has-outputs? $context))
	    (t
	     ;; attempt container dispatch only if all children are quiescent
	     (dispatch-container $context))))))))


(defun map-child-names-to-contexts ($context children-names)
  (mapcar #'(lambda (child-name) (lookup-child $context child-name)) children-names))

(defun any-child-had-outputs (booleans)
  (apply #'and booleans)) ;; fold all booleans into one big AND

(defun dispatch-each-child (children-contexts)
  ;; return list of booleans, t if child produced output
  (mapcar #'run-once children-contexts))

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


(defun route-children-outputs (container-context children-contexts)
  ;; move all outputs from children to other children (or to self's output)
  ;; remap etags along the way (in general an output etag will not be the same as a target's etag, and, a target's etag will not be the same as another target's etag)
  (cond
    ((null children-contexts) nil)
    (t (let ((child (car children-contexts)))
	 (route-child-outputs container-context child)
	 (route-children-outputs container-context (cdr children-contexts))))))


(defun route-child-outputs (container-context child-context)
  (route-child-outputs-recursively container-context
                                   ($get-field child-context 'name)
                                   ($get-field child-context 'output-queue)))

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
  (let ((target-context (get-context-from-name target-component-name container-context)))
    (let ((direction (determine-port-direction receiver target-context)))
      (cond
       ((eq 'input direction) (enqueue-input target-context message))
       (t      (enqueue-output target-context message))))))
    
(defun new-message (etag data previous-message)
  ;; etag data (trace ...)
  (cons etag (cons data (cons previous-message (third previous-message)))))

(defun enqueue-input (context message)
  ($set-field context 'input-queue (append ($get-field context 'input-queue) (list message))))

(defun enqueue-output (context message)
  ($set-field context 'output-queue (append ($get-field context 'output-queue) (list message))))

(defun dequeue-input (context)
  (when ($get-field context 'input-queue)
    (let ((q ($get-field context 'input-queue)))
      (pop q))))
      
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
  (cons
   (cons 'prototype prototype)
   (cons 'children
   (instantiate-children 
    prototype-bag
    parent
    ($get-field prototype 'children)
    (instantiate-locals
     ($get-field prototype 'locals)
     (list 
      '(input-queue nil)
      '(output-queue nil)
      `(ancestor  ,parent)
      (copy-prototype prototype))))))

(defun instantiate-children (prototype-bag parent children descriptor)
  (cond 
    ((null children) descriptor)
    (t (cons 
	(instantiate-child prototype-bag parent (car children))
	(instantiate-children prototype-bag parent (cdr children) descriptor)))))

(defun copy-prototype (p)
  (cond
    ((null p) nil)
    (t 
     (cons (car p) (copy-prototype (cdr p))))))

(defun instantiate-child (prototype-bag parent child-pair)
  (let ((name (first child-pair))
	(prototype-name (second child-pair)))
    (cons
     name
     (instantiate (fetch-prototype-by-name prototype-name prototype-bag)
		  parent
		  prototype-bag))))

(defun instantiate-locals (locals descriptor)
  (cond
   ((null locals) descriptor)
   (t (cons (instantiate-local (car locals))
            (instantiate-locals (cdr locals) descriptor)))))

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
     (get-context (car children)))
    (t (get-context-from-children-by-name name (cdr children) container-context))))

(defun get-child-name (pair)
  (first pair))

(defun get-context (pair)
  (second pair))

(defun get-component-from-receiver (receiver-port)
  (first receiver-port))

(defun leaf? ($context)
  (not (null ($get-field $context 'children))))
  
(defun has-outputs? ($context)
  (not (null ($get-field $context 'output-queue))))
