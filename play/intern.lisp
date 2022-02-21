(defun intern (name)
  (multiple-value-bind (found answer)
      (lookup name)
    (insert-if-not-found found answer name)))
