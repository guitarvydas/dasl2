;; prototypes

(defparameter *lookup* 
  `(
    (name  . "lookup")
    (etags  . ("name" "found" "answer"))
    (locals  . nil)
    ;; (initially   (%asc "{%inject (name) >> [scroll through atoms](name)}"))
    (initially . 
               ,(lambda ($context)
                  (format *standard-output* "lookup initially~%")
                 (let ((name ($get-field ($get-field $context '$args) 'name)))
                   ($inject '("scroll through atoms" . "name") ($get-field ($get-field $context '$args) 'name) $context nil))))
    ;; (handler   (%asc "{
    ;; ?[
    ;;   | found: 
    ;;       set $ found = $message.data
    ;;       $conclude
    ;;   | answer:
    ;;       set $.answer = $message.data
    ;; ]?
    ;; }"))
    (handler .  
	     ,(lambda ($context $message)
                  (format *standard-output* "lookup handler~%")
	       (cond
		 ((string= "found" (get-etag-from-message $message))
		  (let (($context ($maybe-set-field $context 'found (get-data-from-message $message))))
                    ($dispatch-conclude $context)))
		 ((string= "answer" (get-etag-from-message $message))
		  (let (($context2 ($maybe-set-field $context 'answer (get-data-from-message $message))))
                    (declare (ignore $context2))))
		 (t (error-unhandled-message $message $context)))))
    ;; (finally . (%asc "{%return (found answer)}"))
    (finally  .
              ,(lambda ($context) (declare (ignore args))
                  (format *standard-output* "lookup finally~%")
                 (values ($get-field $context "answer")
                         ($get-field $context "found"))))
    ;; local name . name of proto
    (children .  (("$self". "lookup")
                  ("scroll through atoms" . "scroll through atoms")
                  ("match single atom name" . "match single atom name")
                  ("unsuccessful" . "unsuccessful")
                  ("successful" . "successful")))
    (connections .  (
		    (("$self" "name") . (("scroll through atoms" "name")))
		    (("scroll through atoms" "EOF") . (("unsuccessful" "conclude")))
		    (("scroll through atoms" "try 1 name match") . (("match single atom name" "go")))
		    (("match single atom name" "mismatch") . (("scroll through atoms" "advance")))
		    (("match single atom name" "ok") . (("successful" "conclude")))
		    (("unsuccessful" "found") . (("$self" "found")))
		    (("successful" "found") . (("$self" "found")))
		    (("successful" "answer") . (("$self" "answer")))
		    ))
    ))

(defparameter *scroll-through-atoms*
  `(
    (name  . "scroll through atoms")
    (etags  . ("name" "advance" "EOF" "try 1 name match"))
    (inputs .  ("name" "advance"))
    (outputs .  ("EOF" "try 1 name match"))
    (locals .  nil)
    ;; (initially . (%asc "
    ;;  {
    ;;   $if ?no more atoms $then
    ;;       $send $trigger >> EOF
    ;;   $end if
    ;;  }"))
    (initially   .
	       (lambda ($context)
                  (format *standard-output* "[scroll through atoms] initially~%")
		 (let ((atom-memory ($get-field ($get-field $context 'args) 'atom-memory)))
		   (cond
		     ((?eof atom-memory)
		      ($send '("scroll through atoms" "EOF") $no $context '("scroll-through-atoms" "initially")))
		     (t nil)))))
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
    (handler . 
	     ,(lambda ($context $message)
                  (format *standard-output* "[scroll through atoms] handler~%")
		(let ((atom-memory ($get-field ($get-field-recursive $context 'args) 'atom-memory)))
                  (cond
                   ((string= "name" (get-etag-from-message $message))
                    ($send '("scroll through atoms" "try 1 name match") (current-atom-index atom-memory) $context $message))
                   ((string= "advance" (get-etag-from-message $message))
                    (let ((atom-memory ($get-field ($get-field-recursive $context 'args) 'atom-memory)))
                      (@advance-to-next-atom atom-memory)
                      (cond
                       ((?eof atom-memory)
                        ($send '("scroll through atoms" "EOF") $no $context $message))
			   (t ($send '("scroll through atoms" "try 1 name match") (current-atom-index atom-memory) $context $message)))))
                   (t (error-unhandled-message $message $context))))))
    
    (finally  .  nil)
    (children .  nil)
    (connections .  nil)
    ))

(defparameter *match-single-atom-name*
  `(
    (name .  "match single atom name")
    (etags .  ("go" "mismatch" "ok"))
    (inputs .  ("go"))
    (outputs .  ("mismatch" "ok"))
    (locals .  nil)
    (initially .  nil)
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
    (handler . 
	     ,(lambda ($context $message)
                  (format *standard-output* "[match single atom] handler~%")
                (let ((atom-memory ($get-field ($get-field-recursive $context 'args) 'atom-memory)))
                  (cond
                   ((string= "go" (get-etag-from-message $message))
                    ($send '("match single atom name" "ok") (current-atom-index atom-memory) $context $message))
                   (t ($send '("match single atom name" "mismatch") t $context $message))))))
    (finally .  nil)
    (children .  nil)
    (connections .  nil)
    ))

(defparameter *unsuccessful*
  `(
    (name .  "unsuccessful")
    (etags .  ("conclude" "found"))
    (inputs .  ("conclude"))
    (outputs .  ("found"))
    (locals .  nil)
    (initially .  nil)
    ;; (handler . (%asc "{
    ;; ?[ 
    ;;     | conclude: 
    ;; 	    $send $no >> found
    ;; ]?
    ;; }"))
    (handler . 
	     ,(lambda ($context $message)
                  (format *standard-output* "[unsuccessful] handler~%")
	       (cond
		 ((string= "conclude" (get-etag-from-message $message))
		  ($send '("unsuccessful" "found") $no $context $message)
                  ($dispatch-conclude $context))
		 (t (error-unhandled-message $message $context)))))
    (finally .  nil)
    (children .  nil)
    (connections .  nil)
    ))

(defparameter *successful*
  `(
    (name .  "successful")
    (etags .  ("conclude" "found" "answer"))
    (inputs .  ("conclude"))
    (outputs .  ("found" "answer"))
    (locals .  nil)
    (initially .  nil)
    ;; (handler . (%asc "{
    ;; ?[ 
    ;;     | conclude: 
    ;; 	    $send $answer >> answer
    ;; 	    $send $yes >> found
    ;; ]?
    ;; }"))
    (handler . 
	     ,(lambda ($context $message)
                  (format *standard-output* "[successful] handler~%")
                (let ((atom-memory ($get-field ($get-field-recursive $context 'args) 'atom-memory)))
                  (cond
                   ((string= "conclude" (get-etag-from-message $message))
                    ($send '("successful" "answer") (current-atom-index atom-memory) $context $message)
                    ($send '("successful" "found") $yes $context $message)
                    ($dispatch-conclude $context))
                   (t (error-unhandled-message $message $context))))))
    (finally .  nil)
    (children .  nil)
    (connections .  nil)
    ))
  

(defparameter *lookup-signature* 
  `(
    (name .  "lookup")
    ;; input event "name" expects data block with fields ("name")
    ;; output event "found" sends data block ("found")
    ;; output event "answer" sends data block ("answer")
    (etags .  (("name" ("name")) ("found" ("found")) ("answer" ("answer"))))
    (inputs .  ("name"))
    (outputs .  ("found" "answer"))
    ))

(defparameter *scroll-through-atoms-signature*
  `(
    (name .  "scroll through atoms")
    (etags .  (("name" ("name")) ("advance" ("advance")) ("EOF" ("EOF")) ("try 1 name match" ("try 1 name match"))))
    (inputs .  ("name" "advance"))
    (outputs .  ("EOF" "try 1 name match"))
))

(defparameter *match-single-atom-name-signature*
  `(
    (name .  "match single atom name")
    (etags .  (("go" ("go")) ("mismatch" ("mismatch")) ("ok" ("ok"))))
    (inputs .  ("go"))
    (outputs .  ("mismatch" "ok"))
    ))

(defparameter *unsuccessful-signature*
  `(
    (name .  "unsuccessful")
    (etags .  (("conclude" ("conclude")) ("found" ("found"))))
    (inputs .  ("conclude"))
    (outputs .  ("found"))
    ))

(defparameter *successful-signature*
  `(
    (name .  "unsuccessful")
    (etags .  (("conclude" ("conclude")) ("found" ("found")) ("answer" ("answer"))))
    (inputs .  ("conclude"))
    (outputs .  ("found" "answer"))
    ))
