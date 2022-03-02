(defun insert-if-not-found (found answer-if-found name)
  (cond
    (found (send '("Insert If Not Found" "Answer") answer-if-found ...))
    (t (let ((answer (@putatom (split-into-chars name))))
	 (send '("Insert If Not Found" "Answer") answer ...)))))
