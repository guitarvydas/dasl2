(defparameter *lookup*
`(

(name .  "lookup")
(inputs . ( "name"))
(outputs . ( "found" "answer"))
(locals . ( "found" "answer" "name"))
(initially . ,(lambda ($context) 
 ($!local $context "name" Args. "name")

 ($!local $context "answer" nil)

 ($!local $context "found" nil)

($inject '( "scroll through atoms" .  "name") name $context nil)))
(handler . ,(lambda ($context) 
(cond
((string=  "found" (?etag-from-message $message))
 ($!local $context "found" (?data-from-message $message))

($dispatch-conclude $context))
((string=  "answer" (?etag-from-message $message))
 ($!local $context "answer" (?data-from-message $message))))))
(finally . ,(lambda ($context) 
(values foundanswer)))
(children . (
( "self" .  "lookup")
( "scroll through atoms" .  "scroll through atoms")
( "match single atom name" .  "match single atom name")
( "unsuccessful" .  "unsuccessful")
( "successful" .  "successful")))
(connections . (
(( "self" "name" . ( "scroll through atoms" "name")))
(( "scroll through atoms" "EOF" . ( "unsuccessful" "conclude")))
(( "scroll through atoms" "try 1 name match" . ( "match single atom name" "go")))
(( "match single atom name" "mismatch" . ( "scroll through atoms" "advance")))
(( "match single atom name" "ok" . ( "successful" "conclude")))
(( "unsuccessful" "found" . ( "self" "found")))
(( "successful" "found" . ( "self" "found")))
(( "successful" "answer" . ( "self" "answer")))))))
(defparameter *scroll through atoms*
`(

(name .  "scroll through atoms")
(inputs . ( "name" "advance"))
(outputs . ( "EOF" "try 1 name match"))
(locals . ( "atom-memory"))
(initially . ,(lambda ($context) 
 ($!local $context "atom-memory" Args. "atom-memory")

(let (($pred atom-memory. "eof?"()))
((equal t $pred) 
($send '("scroll through atoms"  "EOF") nil $context '("scroll through atoms" . "initially")))
((equal nil $pred) nil))))
(handler . ,(lambda ($context) 
 ($!local $context "atom-memory" Args∞ "atom-memory")
(cond
((string=  "name" (?etag-from-message $message))
($send '("scroll through atoms"  "try 1 name match") t $context '("scroll through atoms" .  "name"))

($dispatch-conclude $context))
((string=  "advance" (?etag-from-message $message))
atom-memory. "advanceToNextAtom"()

(let (($pred atom-memory. "eof?"()))
((equal t $pred) 
($send '("scroll through atoms"  "EOF") nil $context '("scroll through atoms" .  "advance")))
((equal nil $pred) 
($send '("scroll through atoms"  "try 1 name match") t $context '("scroll through atoms" .  "advance")))))))))
(finally . nil)
(children . ())
(connections . ())))
(defparameter *match single atom name*
`(

(name .  "match single atom name")
(inputs . ( "name" "advance"))
(outputs . ( "EOF" "try 1 name match"))
(locals . ( "atom-memory"))
(initially . nil)
(handler . ,(lambda ($context) 
(cond
((string=  "go" (?etag-from-message $message))
(let (($pred match string ()))
((equal t $pred) 
($send '("match single atom name"  "ok") t $context '("match single atom name" .  "go")))
((equal nil $pred) 
($send '("match single atom name"  "mismatch") t $context '("match single atom name" .  "go"))))))))
(finally . nil)
(children . ())
(connections . ())))
(defparameter *unsuccessful*
`(

(name .  "unsuccessful")
(inputs . ( "conclude"))
(outputs . ( "found"))
(locals . ())
(initially . nil)
(handler . ,(lambda ($context) 
(cond
((string=  "conclude" (?etag-from-message $message))
($send '("unsuccessful"  "found") nil $context '("unsuccessful" .  "conclude"))))))
(finally . nil)
(children . ())
(connections . ())))
(defparameter *successful*
`(

(name .  "successful")
(inputs . ( "conclude"))
(outputs . ( "found" "answer"))
(locals . ())
(initially . nil)
(handler . ,(lambda ($context) 
(cond
((string=  "conclude" (?etag-from-message $message))
($send '("successful"  "answer") (?data-from-message $message) $context '("successful" .  "conclude"))

($send '("successful"  "found") t $context '("successful" .  "conclude"))))))
(finally . nil)
(children . ())
(connections . ())))

(defparameter *lookup-signature*
(name .  "lookup")
(inputs . ( "name"))
(outputs . ( "found" "answer")))
(defparameter *scroll through atoms-signature*
(name .  "scroll through atoms")
(inputs . ( "name" "advance"))
(outputs . ( "EOF" "try 1 name match")))
(defparameter *match single atom name-signature*
(name .  "match single atom name")
(inputs . ( "name" "advance"))
(outputs . ( "EOF" "try 1 name match")))
(defparameter *unsuccessful-signature*
(name .  "unsuccessful")
(inputs . ( "conclude"))
(outputs . ( "found")))
(defparameter *successful-signature*
(name .  "successful")
(inputs . ( "conclude"))
(outputs . ( "found" "answer")))
