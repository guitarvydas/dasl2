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


		(cond 
		  ((string= "found" (?etag-from-message $message)) 
		   ($!local $context "found" (?data-from-message $message))
		   ($dispatch-conclude $context))
		  ((string= "answer" (?etag-from-message $message)) 
		   ($!local $context "answer" (?data-from-message $message))))))
    (finally . nil)
    (children . nil)
    (connections . nil)))

(defparameter *match-single-atom-name-signature*
  (name . "match single atom name")
  (etags . ("name" "advance" "EOF" "try 1 name match" ))
  (inputs . ("name" "advance" ))
  (outputs . ("EOF" "try 1 name match" )))
