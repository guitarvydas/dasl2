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
,(defparameter *scroll-through-atoms*
`(
(name . "scroll through atoms")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
($args . nil)
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))
(nets . ())
(locals . ())
(initially . 
,(lambda ($context) 
(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))

(cond (("eof?" "atom-memory") |Yes:
($send '("scroll through atoms" "EOF") No)|No:
nil)))))
(handler . 
,(lambda ($context $message) 
(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))
)⎡•"name":
($send '("scroll through atoms" "try 1 name match") Trigger)
($dispatch-conclude $context)•"advance":
("advanceToNextAtom" "atom-memory")
(cond (("eof?" "atom-memory") |Yes:
($send '("scroll through atoms" "EOF") No)|No:
($send '("scroll through atoms" "try 1 name match") Trigger)))⎦))
(finally . nil)
(children . nil)
(connections . nil)))
,(defparameter *match-single-atom-name*
`(
(name . "match single atom name")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
($args . nil)
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message) ⎡•"go":
(cond ((""match string "") |Yes:
($send '("match single atom name" "ok") Trigger)|No:
($send '("match single atom name" "mismatch") Trigger)))⎦))
(finally . nil)
(children . nil)
(connections . nil)))
,(defparameter *unsuccessful*
`(
(name . "unsuccessful")
(etags . ("conclude" "found" ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message) ⎡•"conclude":
($send '("unsuccessful" "found") No)⎦))
(finally . nil)
(children . nil)
(connections . nil)))
,(defparameter *successful*
`(
(name . "successful")
(etags . ("conclude" "found" "answer" ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" "answer" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message) ⎡•"conclude":
($send '("successful" "answer") (?edata-from-message ?data))
($send '("successful" "found") Yes)⎦))
(finally . nil)
(children . nil)
(connections . nil)))

(defparameter *lookup-signature*
(name . "lookup")
(etags . ("name" "found" "answer" ))
(inputs . ("name" ))
(outputs . ("found" "answer" ))),
(defparameter *scroll-through-atoms-signature*
(name . "scroll through atoms")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))),
(defparameter *match-single-atom-name-signature*
(name . "match single atom name")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))),
(defparameter *unsuccessful-signature*
(name . "unsuccessful")
(etags . ("conclude" "found" ))
(inputs . ("conclude" ))
(outputs . ("found" ))),
(defparameter *successful-signature*
(name . "successful")
(etags . ("conclude" "found" "answer" ))
(inputs . ("conclude" ))
(outputs . ("found" "answer" )))
