
  
(defun lookup (name)
  (let ((prototypes (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context (instantiate *lookup* 'no-ancestor prototypes)))
      ($dispatch top-context name))))

