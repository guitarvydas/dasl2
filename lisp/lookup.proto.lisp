;; prototypes

(defparameter *lookup* 
  `(
    (name . "lookup")
    (signals . ("name" "found" "answer"))
    (locals . nil)
    (initially . (%asc "{%inject (name) >> [scroll through atoms](name)}"))
    ;; (handler . (%asc "{
    ;; ?[
    ;;   | found: 
    ;;       set $.found = $message.data
    ;;       $conclude
    ;;   | answer:
    ;;       set $.answer = $message.data
    ;; ]?
    ;; }"))
    niy
    ;; (finally . (%asc "{%return (found answer)}"))
    niy
                  ;; local name . name of proto
    (children . (("$self" . nil)
		 ("scroll through atoms" . "scroll through atoms")
		 ("match single atom name" . "match single atom name")
		 ("unsuccessful" . "unsuccessful")
		 ("successful" . "successful")))
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
    (locals . nil)
    ;; (initially . (%asc "
    ;;  {
    ;;   $if ?no more atoms $then
    ;;       $send $trigger >> EOF
    ;;   $end if
    ;;  }"))
    niy
    ;; (handler . (%asc "
    ;;  {
    ;;   ?[ 
    ;;     | name: 
    ;;         $send name >> (try 1 name match)
    ;; 	| advance: 
    ;;         @advance to next atom
    ;; 	    $send name >> (try 1 name match)
    ;;   ]?
    ;;  }"))
    niy
    (finally  . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *match-single-atom-name*
  `(
    (name . "match single atom name")
    (signals . ("go" "mismatch" "ok"))
    (inputs . ("go"))
    (outputs . ("mismatch" "ok"))
    (locals . nil)
    (initially . nil)
    ;; (handler . (%asc "{
    ;; ?[ 
    ;;     | go: 
    ;;         $if (?match-string) $then
    ;; 	      $send $trigger >> ok
    ;;         $endif
    ;; 	| *: 
    ;;         $send $trigger >> mismatch
    ;; ]?
    ;; }"))
    niy
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *unsuccessful*
  `(
    (name . "unsuccessful")
    (signals . ("conclude" "found"))
    (inputs . ("conclude"))
    (outputs . ("found"))
    (locals . nil)
    (initially . nil)
    ;; (handler . (%asc "{
    ;; ?[ 
    ;;     | conclude: 
    ;; 	    $send $no >> found
    ;; ]?
    ;; }"))
    niy
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))

(defparameter *successful*
  `(
    (name . "successful")
    (signals . ("conclude" "found" "answer"))
    (inputs . ("conclude"))
    (outputs . ("found" "answer"))
    (locals . nil)
    (initially . nil)
    ;; (handler . (%asc "{
    ;; ?[ 
    ;;     | conclude: 
    ;; 	    $send $answer >> answer
    ;; 	    $send $yes >> found
    ;; ]?
    ;; }"))
    niy
    (finally . nil)
    (children . nil)
    (connections . nil)
    ))
  

(defparameter *lookup-signature* 
  `(
    (name . "lookup")
    ;; input event "name" expects data block with fields ("name")
    ;; output event "found" sends data block ("found")
    ;; output event "answer" sends data block ("answer")
    (signals . (("name" ("name")) ("found" ("found")) ("answer" ("answer"))))
    (inputs . ("name"))
    (outputs . ("found" "answer"))
    ))

(defparameter *scroll-through-atoms-signature*
  `(
    (name . "scroll through atoms")
    (signals . (("name" ("name")) ("advance" ("advance")) ("EOF" ("EOF")) ("try 1 name match" ("try 1 name match"))))
    (inputs . ("name" "advance"))
    (outputs . ("EOF" "try 1 name match"))
))

(defparameter *match-single-atom-name-signature*
  `(
    (name . "match single atom name")
    (signals . (("go" ("go")) ("mismatch" ("mismatch")) ("ok" ("ok"))))
    (inputs . ("go"))
    (outputs . ("mismatch" "ok"))
    ))

(defparameter *unsuccessful-signature*
  `(
    (name . "unsuccessful")
    (signals . (("conclude" ("conclude")) ("found" ("found"))))
    (inputs . ("conclude"))
    (outputs . ("found"))
    ))

(defparameter *successful-signature*
  `(
    (name . "unsuccessful")
    (signals . (("conclude" ("conclude")) ("found" ("found")) ("answer" ("answer"))))
    (inputs . ("conclude"))
    (outputs . ("found"))
    (outputs . ("answer"))
    ))
