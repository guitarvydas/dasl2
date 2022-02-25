
  
(defun lookup (name mem)
  (let ((prototypes (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context (instantiate *lookup* nil prototypes)))
      (let ((top-context ($maybe-set-field top-context 'args `( (name . ,name) (atom-memory . ,mem) ))))
        ($dispatch top-context)))))


