(defparameter *lookup*
`(
(name . "lookup")
(etags . ("name" "found" "answer" ))
($args . nil)
(inputs . ("name" ))
(outputs . ("found" "answer" ))
(nets . ("⇒₁" "⇒₂" "⇒₃" "⇒₄" "⇒₅" "⇒₆" "⇒₇" "⇒₈" ))
(locals . ("found" "answer" "name" ))
(initially . 
,(lambda ($context) 
(let ((name ($?field ($?field $context '$args) 'name)))

($!local "answer" No)
($!local "found" No)
($inject '("scroll through atoms" . "name") name))))
(handler . 
,(lambda ($context $message) ⎡•"found":
($!local $context "found" (?data-from-message ?data))
($dispatch-conclude $context)•"answer":
($!local $context "answer" (?data-from-message ?data))⎦))
(finally . 
,(lambda ($context) 
(values 
($?local $context "found")
($?local $context "answer"))))
(children . 
("$self" . "lookup")
("scroll through atoms" . "scroll through atoms")
("match single atom name" . "match single atom name")
("unsuccessful" . "unsuccessful")
("successful" . "successful"))
(connections . (
(("$self" . "name") . (("scroll through atoms" . "name")))
(("scroll through atoms" . "EOF") . (("unsuccessful" . "conclude")))
(("scroll through atoms" . "try 1 name match") . (("match single atom name" . "go")))
(("match single atom name" . "mismatch") . (("scroll through atoms" . "advance")))
(("match single atom name" . "ok") . (("successful" . "conclude")))
(("unsuccessful" . "found") . (("self" . "found")))
(("successful" . "found") . (("self" . "found")))
(("successful" . "answer") . (("self" . "answer")))))))

(defparameter *lookup-signature*
(name . "lookup")
(etags . ("name" "found" "answer" ))
(inputs . ("name" ))
(outputs . ("found" "answer" )))
