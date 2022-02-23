(defun $get-field ($context field-symbol)
  (let ((v (assoc field-symbol $context)))
    (when v
      (second v))))      

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
  (loop
    while (continue $context)
    do (run-once $context)))

(defun run-once ($context)
  (let ((children-names ($get-field $context 'children)))
    (let ((children (map-child-names-to-contexts $context children-names)))
      (let ((list-had-outputs (dispatch-each-child children)))
	(let ((any-child-outputs (any-child-had-outputs list-had-outputs)))
	  (cond 
	    ((any-child-outputs
	      (route-child-outputs $context children)
	      t))	     
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
  (let ((q ($get container-context 'input-queue)))
    (cond
      ((not (null q))
       (let ((message (pop q)))
	 (let ((
       )))))
      (t nil))))

(defun find-connection-by-sender (port connection-list)
  (cond
    ((null connection-list)
     (error-cannot-find-sender port connection-lis))
    ( t
      (cond ((port-same? port (get-sender-port (car connection-list)))
	     connection-list)
	    (t (find-sender port (cdr connection-list)))))))

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
  (route-child-outputs-recursively container-context ($get-field child-context 'output-queue)))

(defun route-child-outputs-recursively (container-context output-messages)
  (cond
    ((null output-messages) nil)
    (t (let ((output-message (car output-messages)))
	 (route-message container-context output-message)))))

(defun route-message (container-context message)
  (let ((connection-map ($get-field container-context 'connections)))
    (let ((connection (find-connection-by-sender (get-sender-from-message message) connection-map)))
      (let ((receivers (get-receivers-from-connection connection)))
	(foreach receiver-port in receivers
		 do (route-single-message receiver-port message container-context))))))

(defun route-single-message (receiver-port message)
  (let ((etag (get-etag-from-port receiver-port)))
    (let ((m (new-message etag (get-data-from-message message))))
      (enqueue-message receiver-port m container-context))))

(defun enqueue-message (port message container-context)
  (let ((target-component (get-component-from-message container-context message)))
    (let ((input? (determine-port-direction port)))
      (cond
	(input? (enqueue-input target-component message))
	(t      (enqueue-output target-component message))))))
    
