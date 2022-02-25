
  
(defun lookup (name mem)
  (let ((prototypes (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context (instantiate *lookup* 'no-ancestor prototypes)))
      (let ((top-context ($set-field top-context 'args `( (name . ,name) (atom-memory . ,mem) ))))
        ($dispatch top-context name)))))

(defun test ()
  (lookup "QUOTE"))

