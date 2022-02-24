
  
(defun lookup (name)
  (let ((components (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context (instantiate *lookup* 'no-ancestor)))
      ($dispatch top-context components name))))

