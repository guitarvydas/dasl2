    ;; input event "name" expects data block ("name")
    ;; output event "found" sends data block ("found")
    ;; output event "answer" sends data block ("answer")

(defparameter *lookup* 
  `(
    (name . "lookup")
    (signals . ("name" "found" "answer"))
    (inputs . ("name"))
    (outputs . ("found" "answer"))
    (ancestor . nil)
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially .
	       (lambda (name $context)
		 ($set $context "name" name)
		 ($inject $context '("scroll through atoms" "name") name)))
    (handler . 
	     (lambda ($context $message)
	       (cond
		 ((string= "found" ($message-signal $message))
		  ($set $context "found" ($message-data $message))
		  ($conclude))
		 ((string= "answer" ($message-signal $message))
		  ($set $context "answer" ($message-data $message)))
		 (t (%message-error $context "lookup" $message)))))
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
    (signals . ("name" "advance" "EOF" "try 1 name match"))
    (inputs . ("name" "advance"))
    (outputs . ("EOF" "try 1 name match"))
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
		 (t (%message-error $context "scroll through atoms" $message)))))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *match-single-atom-name*
  `(
    (name . "match single atom name")
    (eventTag in "go" ("go"))
    (eventTag out "mismatch" ("mismatch"))
    (eventTag out "ok" ("ok"))
    (inputs . ("go"))
    (outputs . ("mismatch" "ok"))
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
    (eventTag in "conclude" ())
    (eventTag out "found" ("found"))
    (inputs . ("conclude"))
    (outputs . ("found")
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . nil)
    (handler . (%asc "{
    ?[ 
        | conclude: 
	    $send $no >> found
    ]?
    }"))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *successful*
  `(
    (name . "successful")
    (eventTag in "conclude" ())
    (eventTag out "found" ("found"))
    (eventTag out "answer" ("answer"))
    (inputs . ("conclude"))
    (outputs . ("found" "answer")
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . nil)
    (handler . (%asc "{
    ?[ 
        | conclude: 
	    $send $answer >> answer
	    $send $yes >> found
    ]?
    }"))
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))
  
