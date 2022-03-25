(defparameter *match-single-atom-name*
`(
(name . "match single atom name")
(etags . ("go" "mismatch" "ok" ))
($args . nil)
(inputs . ("go" ))
(outputs . ("mimatch" "ok" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message)

(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))
)(cond 
((string= "go" (?etag-from-message $message)) 
(let (($pred (match-string- "atom-memory""?edata")))
(cond 
((equal t $pred)
($send '("match single atom name" "ok") t))
(t 
($send '("match single atom name" "mismatch") t)))))
(t 
nil))
($send '("match single atom name" "mismatch") t)))
(finally . nil)
(children . nil)
(connections . nil)))

(defparameter *match-single-atom-name-signature*
(name . "match single atom name")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" )))
