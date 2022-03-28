(defparameter *lookup*
`(
(name . "lookup")
(etags . (("name" ("name")) ("found" ("found")) ("answer" ("answer")) ))
($args . nil)
(inputs . ("name" ))
(outputs . ("found" "answer" ))
(nets . ("⇒₁" "⇒₂" "⇒₃" "⇒₄" "⇒₅" "⇒₆" "⇒₇" "⇒₈" ))
(locals . ("found" "answer" "name" ))
(initially . 
,(lambda ($context) 
(let ((name ($?field ($?field $context '$args) 'name)))

($!local $context "answer" nil)
($!local $context "found" nil)
($inject '("scroll through atoms" . "name") name $context nil))))
(handler . 
,(lambda ($context $message)


(cond 
((string= "found" (?etag-from-message $message)) 
($!local $context "found" (?data-from-message $message))
($dispatch-conclude $context))
((string= "answer" (?etag-from-message $message)) 
($!local $context "answer" (?data-from-message $message)))
(t (error-unhandled-message $context $message)))))
(finally . 
,(lambda ($context) 
(values 
($?local $context "found")
($?local $context "answer"))))
(children . (
("$self" . "lookup")
("scroll through atoms" . "scroll through atoms")
("match single atom name" . "match single atom name")
("unsuccessful" . "unsuccessful")
("successful" . "successful")))
(connections . (
(("$self" . "name") . (("scroll through atoms" . "name")))
(("scroll through atoms" . "EOF") . (("unsuccessful" . "conclude")))
(("scroll through atoms" . "try 1 name match") . (("match single atom name" . "go")))
(("match single atom name" . "mismatch") . (("scroll through atoms" . "advance")))
(("match single atom name" . "ok") . (("successful" . "conclude")))
(("unsuccessful" . "found") . (("$self" . "found")))
(("successful" . "found") . (("$self" . "found")))
(("successful" . "answer") . (("$self" . "answer")))))))
(defparameter *scroll-through-atoms*
`(
(name . "scroll through atoms")
(etags . (("name" ("name")) ("advance" ("advance")) ("EOF" ("EOF")) ("try 1 name match" ("try 1 name match")) ))
($args . nil)
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))
(nets . ())
(locals . ())
(initially . 
,(lambda ($context) 
(let ((atom-memory ($?field ($?field-recursive $context '$args) 'atom-memory)))

(let (($pred (?eof atom-memory)))
(cond 
((equal t $pred)
($send '("scroll through atoms" . "EOF") nil $context $message))
((equal nil $pred)
nil))))))
(handler . 
,(lambda ($context $message)

(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))


(cond 
((string= "name" (?etag-from-message $message)) 
($send '("scroll through atoms" . "try 1 name match") t $context $message)
($dispatch-conclude $context))
((string= "advance" (?etag-from-message $message)) 
(@advance-to-next-atom atom-memory)
(let (($pred (?eof atom-memory)))
(cond 
((equal t $pred)
($send '("scroll through atoms" . "EOF") nil $context $message))
(t 
($send '("scroll through atoms" . "try 1 name match") t $context $message)))))
(t (error-unhandled-message $context $message))))))
(finally . nil)
(children . nil)
(connections . nil)))
(defparameter *match-single-atom-name*
`(
(name . "match single atom name")
(etags . (("go" ("go")) ("mismatch" ("mismatch")) ("ok" ("ok")) ))
($args . nil)
(inputs . ("go" ))
(outputs . ("mimatch" "ok" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message)

(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))


(cond 
((string= "go" (?etag-from-message $message)) 
(let (($pred (match-string atom-memory (?data-from-message $message) )))
(cond 
((equal t $pred)
($send '("match single atom name". "ok") (current-atom-index atom-memory) $context $message))
(t 
($send '("match single atom name" . "mismatch") t $context $message)))))
(t 
nil))
($send '("match single atom name" . "mismatch") t $context $message))))
(finally . nil)
(children . nil)
(connections . nil)))
(defparameter *unsuccessful*
`(
(name . "unsuccessful")
(etags . (("conclude" ("conclude")) ("found" ("found")) ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message)


(cond 
((string= "conclude" (?etag-from-message $message)) 
($send '("unsuccessful" . "found") nil $context $message))
(t (error-unhandled-message $context $message)))))
(finally . nil)
(children . nil)
(connections . nil)))
(defparameter *successful*
`(
(name . "successful")
(etags . (("conclude" ("conclude")) ("found" ("found")) ("answer" ("answer")) ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" "answer" ))
(nets . ())
(locals . ())
(initially . nil)
(handler . 
,(lambda ($context $message)


(cond 
((string= "conclude" (?etag-from-message $message)) 
($send '("successful" . "answer") (?data-from-message $message) $context $message)
($send '("successful" . "found") t $context $message))
(t (error-unhandled-message $context $message)))))
(finally . nil)
(children . nil)
(connections . nil)))

(defparameter *lookup-signature*
`(
(name . "lookup")
(etags . (("name" ("name")) ("found" ("found")) ("answer" ("answer")) ))
(inputs . ("name" ))
(outputs . ("found" "answer" ))))
(defparameter *scroll-through-atoms-signature*
`(
(name . "scroll through atoms")
(etags . (("name" ("name")) ("advance" ("advance")) ("EOF" ("EOF")) ("try 1 name match" ("try 1 name match")) ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))))
(defparameter *match-single-atom-name-signature*
`(
(name . "match single atom name")
(etags . (("name" ("name")) ("advance" ("advance")) ("EOF" ("EOF")) ("try 1 name match" ("try 1 name match")) ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))))
(defparameter *unsuccessful-signature*
`(
(name . "unsuccessful")
(etags . (("conclude" ("conclude")) ("found" ("found")) ))
(inputs . ("conclude" ))
(outputs . ("found" ))))
(defparameter *successful-signature*
`(
(name . "successful")
(etags . (("conclude" ("conclude")) ("found" ("found")) ("answer" ("answer")) ))
(inputs . ("conclude" ))
(outputs . ("found" "answer" ))))
