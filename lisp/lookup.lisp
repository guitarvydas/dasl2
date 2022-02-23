(defparameter *lookup* 
  `(
    (name . "lookup")
    (etags . ("name" "found" "answer"))
    (ancestor . nil)
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially .
	       (lambda ($context &rest args)
		 (destructuring-bind (name) args
		   ($set $context "name" name)
		   ($inject $context '("scroll through atoms" "name") ,name))))
    (handler . 
	     (lambda ($context $message)
	       (cond
		 ((string= "found" ($message-signal $message))
		  ($set $context "found" ($message-data $message))
		  ($dispatch-conclude))
		 ((string= "answer" ($message-signal $message))
		  ($set $context "answer" ($message-data $message)))
		 (t ($message-error $context "lookup" $message)))))
    (finally .
	     (lambda ($context)
	       (values ($get $context "found") ($get $context "answer"))))
    (children . ("$self" "scroll through atoms" "match single atom name" "unsuccessful" "successful"))
    (connections . (
		    ("$self" "name") (("scroll through atoms" "name"))
		    ("scroll through atoms" "EOF") (("unsuccessful" "conclude"))
		    ("scroll through atoms" "try 1 name match") (("match single atom name" "go"))
		    ("match single atom name" "mismatch") (("scroll through atoms" "advance"))
		    ("match single atom name" "ok") (("successful" "conclude"))
		    ("unsuccessful" "found") (("$self" "found"))
		    ("successful" "found") (("$self" "found"))
		    ("successful" "answer") (("$self" "answer"))
		    ))
    ))

(defparameter *scroll-through-atoms*
  `(
    (name . "scroll through atoms")
    (etags . ("name" "advance" "EOF" "try 1 name match"))
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially .
	       (lambda ($context)
		 (cond 
		   ((no-more-atoms? $context)
		    ($send $context '("scroll through atoms" "EOF") t)))))
    (handler .
	     (lambda ($context $message)
	       (cond
		 ((string= "name" ($message-signal $message))
		  ($send $context '("scroll through atoms" "try 1 name match") ($get $context "name")))
		 ((string= "advance" ($message-signal $message))
		  (advance-to-next-atom $context)
		  ($send $context '("scroll through atoms" "try 1 name match") ($get $context "name")))
		 (t ($message-error $context "scroll through atoms" $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *match-single-atom-name*
  `(
    (name . "match single atom name")
    (etags. ("go" "mismatch" "ok"))
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . nil)
    (handler . 
	     (lambda ($context $message)
	       (cond
		 ((string= "go" ($message-signal $message))
		  ($send $context '("match single atom name" "ok") ($get $context "answer")))
		 (t 
		  ($send $context '("match single atom name" "mismatch") t)))))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *unsuccessful*
  `(
    (name . "unsuccessful")
    (etags . ("conclude" "found"))
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . nil)
    (handler .
	     (lambda ($context $message)
	       (cond
		 ((string= "conclude" ($message-signal $message))
		  ($send $context '("unsuccessful" "found") $no))
		 (t ($message-error $context "unsuccessful" $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *successful*
  `(
    (name . "successful")
    (etags . ("conclude" "found" "answer"))
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . nil)
    (handler .
	     (lambda ($context $message)
	       (cond
		 ((string= "conclude" ($message-signal $message))
		  ($send $context '("successful" "answer") ($message-data $message))
		  ($send $context '("successful" "found") $no))
		 (t ($message-error $context "successful" $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))
  

  
(defun lookup (name)
  (let ((components (list *lookup* *scroll-through-atoms* *match-single-atom-name* *unsuccessful* *successful*)))
    (let ((top-context *lookup*))
      ($dispatch top-context components name))))
    
