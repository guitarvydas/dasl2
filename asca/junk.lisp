(defparameter *lookup*
  `(
    (name . "lookup")
    (etags . ("name" "found" "answer" ))
    ($args . nil)
    (inputs . ("name" ))
    (outputs . ("found" "answer" ))
    (nets . ("⇒₁" "⇒₂" "⇒₃" "⇒₄" "⇒₅" "⇒₆" "⇒₇" "⇒₈" ))
    (locals . ("found" "answer" "name" ))
    #+nil(initially . 
	       ,(lambda ($context) 
		  (let ((name ($?field ($?field $context '$args) 'name)))

		    ($!local $context "answer" nil)
		    ($!local $context "found" nil)
		    ($inject '("scroll through atoms" . "name") name $context nil))))
    #+nil(handler . 
	     ,(lambda ($context $message)


		(cond 
		  ((string= "found" (?etag-from-message $message)) 
		   ($!local $context "found" (?data-from-message $message))
		   ($dispatch-conclude $context))
		  ((string= "answer" (?etag-from-message $message)) 
		   ($!local $context "answer" (?data-from-message $message)))
		  (t (error-unhandled-message $context $message)))))
    #+nil(finally . 
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
