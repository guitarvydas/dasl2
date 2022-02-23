(defmacro foreach (v kIn vlist kDo expr)
  (declare (ignore kIn kDo))
  `(mapc #'(lambda (,v) ,expr) ,vlist))
