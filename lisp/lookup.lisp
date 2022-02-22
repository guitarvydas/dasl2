(defparameter *lookup* 
  `(
    (name . "lookup")
    (eventTag in "name" ("name"))
    (eventTag out "found" ("found"))
    (eventTag out "answer" ("answer"))
    (inputs . ("name"))
    (outputs . ("found" "answer"))
    (ancestor . nil)
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . (%asc "{%inject (name) >> [trim leading spaces](name)}"))
    (handler . (%asc "{
    $case 
      go >> $if (?match-string) $then 
	 $Send $trigger >> ok
      $else
	 $Send $trigger >> mismatch
    }"))
    (finally . (%asc "{%return found answer}"))
    (children . ("$self" "scroll through atoms" "match single atom name" "unsuccessful" "successful"))
    (connections . (
		    ("$self" "name") (("scroll through atoms" "name"))
		    ("scroll through atoms" "EOF") (("unsuccessful" "conclude"))
		    ("scroll through atoms" "try 1 name match") (("match single atom name" "go"))
		    ("match single atom name" "mismatch") (("scroll through atoms" "advance"))
		    ("match single atom name" "ok") (("successful" "conclude"))
		    ))
    ))

(defparameter *scroll-through-atoms*
  `(
    (name . "scroll through atoms")
    (eventTag in "name" ("name"))
    (eventTag in "advance" ("advance"))
    (eventTag out "EOF" ("EOF"))
    (eventTag out "try 1 name match" ("try 1 name match"))
    (inputs . ("name" "advance"))
    (outputs . ("EOF" "try 1 name match"))
    (ancestor . "lookup")
    (locals . nil)
    (input-queue . nil)
    (output-queue . nil)
    (initially . (%asc "
     {
      $if ?no more atoms $then
          $send $trigger >> EOF
      $end if
     }"))
    (handler . (%asc "
     {
      ?[ 
        | name: 
            $send name >> (try 1 name match)
	| advance: 
            @advance to next atom
	    $send name >> (try 1 name match)
      ]?
     }"))
    (finally  .(%asc "{%asc{%return found answer}"))
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
    (handler . (%asc "{
    ?[ 
        | go: 
            $if (?match-string) $then
	      $send $trigger >> ok
            $endif
	| *: 
            $send $trigger >> mismatch
    ]?
    }"))
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
  
