(defun $get-field ($context field-symbol)
  (let ((v (assoc field-symbol $context)))
    (when v
      (second v))))      

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

(defparameter *all-components* nil)

(defun $dispatch-add-components (list-of-components)
  (setf *all-components* (append *all-components* list-of-components)))

(defun $dispatch ($context $components &rest args)
  ($dispatch-add-components $components)
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
           (let ((connection (find-connection-by-sender (new-port ($get-field container-context 'name) (get-etag-from-message message) connection-map))))
             (let ((receivers (get-receivers-from-connection connection)))
               (foreach receiver-port in receivers
                        do (route-single-message receiver-port message container-context))
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
  (second p))


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
          (foreach receiver-port in receivers
                   do (route-single-message receiver-instance receiver-port message container-context)))))))

(defun route-single-message (receiver-port message container-context)
  (let ((etag (get-etag-from-message message)))
    (let ((m (new-message etag (get-data-from-message message) message)))
      (enqueue-message receiver-port m container-context))))

(defun enqueue-message (port message container-context)
  (let ((target-component (get-component-from-message container-context message)))
    (let ((input? (determine-port-direction port)))
      (cond
	(input? (enqueue-input target-component message))
	(t      (enqueue-output target-component message))))))
    
(defun new-message (etag data previous-message)
  ;; etag data (trace ...)
  (list etag data (cons previous-message (third previous-message))))

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
  (second message))

(defun new-port (component-name etag)
  (list component-name etag))

(defun get-receivers-from-connection (connection)
  (second connection))

(defun error-cannot-find-sender (port connection-list)
  (format *error-output* "internal error: can't find port ~a in connection list ~a~%" port connection-list)
  (assert nil))

(defun error-cannot-find-child ($context child-name)
  (format *error-output* "internal error: can't find child ~a in context ~a~%" child-name $context)
  (assert nil))

(defun error-cannot-find-prototype (prototype-name)
  (format *error-output* "internal error: can't find prototype ~a~%" prototype-name)
  (assert nil))

(defun lookup-child ($context child-name)
  (lookup-child-recursive $context ($get-field $context 'children) child-name))

(defun lookup-child-recursive ($context children-list child-name)
  (cond
   ((null children-list) (error-cannot-find-child $context child-name))
   ((string= child-name (get-local-child-name (first children-list)))
    (get-local-child-instance (first children-list)))
   (t (lookup-child-recursive $context (rest children-list) child-name))))

(defun get-local-child-name (pair)
  (first pair))
(defun get-local-child-instance (pair)
  (second pair))



(defun instantiate (prototype parent prototype-bag)
  (instantiate-children 
   prototype-bag
   parent
   ($get-field prototype 'children)
   (instantiate-locals
    ($get-field prototype 'locals)
    (cons 
     '(input-queue . nil)
     (cons
      '(output-queue . nil)
      (cons
       `(ancestor . ,parent)
       (copy-prototype prototype)))))))

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
    (cons name nil))) ;; fresh CONS cell for each local, initialized to NIL

(defun fetch-prototype-by-name (prototype-name prototype-bag)
  (cond 
   ((null prototype-bag) (error-cannot-find-prototype prototype-name))
   ((string= prototype-name ($get-field (car prototype-bag) 'name))
    (car prototype-bag))
   (t (fetch-prototype-by-name prototype-name (cdr prototype-bag)))))