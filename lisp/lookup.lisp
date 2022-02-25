
  
(defun lookup (name)
  (let ((prototypes (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context (instantiate *lookup* 'no-ancestor prototypes)))
      ($set top-context 'args (cond 'name name))
      ($dispatch top-context name))))

(defun test ()
  (lookup "QUOTE"))

