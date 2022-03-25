(defparameter *lookup*
  `(
    (name . "lookup")
    (inputs . ("name" ))
    (outputs . ("found" "answer" ))
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
(defparameter *scroll-through-atoms*
  `(
    (name . "scroll through atoms")
    (inputs . ("name" "advance" ))
    (outputs . ("EOF" "try 1 name match" ))
    (locals . ())
    (initially . 
	       ,(lambda ($context) 
		  (let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))

		    (let (($pred (eof? atom-memory)))
		      (cond 
			((equal t $pred)
			 ($send '("scroll through atoms" "EOF") nil $context $message))
			((equal nil $pred)
			 nil))))))
    (handler . 
	     ,(lambda ($context $message)

		(let ((atom-memory ($?field ($?field $context '$args) 'atom-memory)))


		  (cond 
		    ((string= "name" (?etag-from-message $message)) 
		     ($send '("scroll through atoms" "try 1 name match") t $context $message)
		     ($dispatch-conclude $context))
		    ((string= "advance" (?etag-from-message $message)) 
		     (advanceToNextAtom atom-memory)
		     (let (($pred (eof? atom-memory)))
		       (cond 
			 ((equal t $pred)
			  ($send '("scroll through atoms" "EOF") nil $context $message))
			 (t 
			  ($send '("scroll through atoms" "try 1 name match") t $context $message)))))
		    (t (error-unhandled-message $context $message))))))
    (finally . nil)
    (children . nil)
    (connections . nil)))
(defparameter *match-single-atom-name*
  `(
    (name . "match single atom name")
    (inputs . ("go" ))
    (outputs . ("mimatch" "ok" ))
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
			  ($send '("match single atom name" "ok") (current-atom-index atom-memory) $context $message))
			 (t 
			  ($send '("match single atom name" "mismatch") t $context $message)))))
		    (t 
		     nil))
		  ($send '("match single atom name" "mismatch") t $context $message))))
    (finally . nil)
    (children . nil)
    (connections . nil)))
(defparameter *unsuccessful*
  `(
    (name . "unsuccessful")
    (inputs . ("conclude" ))
    (outputs . ("found" ))
    (locals . ())
    (initially . nil)
    (handler . 
	     ,(lambda ($context $message)


		(cond 
		  ((string= "conclude" (?etag-from-message $message)) 
		   ($send '("unsuccessful" "found") nil $context $message))
		  (t (error-unhandled-message $context $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)))
(defparameter *successful*
  `(
    (name . "successful")
    (inputs . ("conclude" ))
    (outputs . ("found" "answer" ))
    (locals . ())
    (initially . nil)
    (handler . 
	     ,(lambda ($context $message)


		(cond 
		  ((string= "conclude" (?etag-from-message $message)) 
		   ($send '("successful" "answer" $context $message) (?data-from-message $message))
		   ($send '("successful" "found") t $context $message))
		  (t (error-unhandled-message $context $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)))

(defparameter *lookup-signature*
  (name . "lookup")
  (inputs . ("name" ))
  (outputs . ("found" "answer" )))
(defparameter *scroll-through-atoms-signature*
  (name . "scroll through atoms")
  (inputs . ("name" "advance" ))
  (outputs . ("EOF" "try 1 name match" )))
(defparameter *match-single-atom-name-signature*
  (name . "match single atom name")
  (inputs . ("name" "advance" ))
  (outputs . ("EOF" "try 1 name match" )))
(defparameter *unsuccessful-signature*
  (name . "unsuccessful")
  (inputs . ("conclude" ))
  (outputs . ("found" )))
(defparameter *successful-signature*
  (name . "successful")
  (inputs . ("conclude" ))
  (outputs . ("found" "answer" )))
