(defun lookup (name)
  (let ((%lookup-1 (lambda (name)
          (let (%continue
		found
		answer
		%map)
          (let 

              (%self-handler (lambda (message) 
                              (cond ((string= "answer" (message-tag message))
                                     (setf answer (message-data message)))
                                    ((string= "found" (message-tag message))
                                     (setf found (message-data message))
                                     (concluded))  ;; discontinue dispatching when "found" is set
                                    (t (assert nil))
                                    )))

	      (%scroll-through-atoms-handler (lambda (message)
					       (cond ((string= "start" (message-tag message))
						      (send '("scroll through atoms" "try 1 name match") t))
						     ((string= "advance" (message-tag message))
						      (advance-to-next-atom)
						      (send '("scroll through atoms" "try 1 name match") t))
					       ))
	      (%match-single-atom-name-handler (lambda (message)
						 (cond ((string= "go" (message-tag message))
							(if (match-string)
							    (send '("match single atom name" "ok") t)
							    (send '("match single atom name" "mismatch") t)
						 ))
              (%unsuccessful-handler (lambda (message)
                              (cond ((string= "conclude" (message-tag message))
                                     (send '("%self" "found") nil message %map))
                                    (t (assert nil))
                                    )))

              (%successful-handler (lambda (message)
                             (cond ((string= "conclude" (message-tag message))
				    ;; order of Send()s matters - send "answer" first, then "found"
                                    (send '("%self" "answer") (current-atom-index atom-memory) message %map)
                                    (send '("successful" "found") t message %map))
                                  (t (assert nil))
                                  )))
	  )
	    
	    (setf %map '(
			 "%self" %self-handler
			 "unsuccessful" %unsuccessful-handler
			 "successful" %successful-handler
			 "scroll through atoms" %scroll-through-atoms-handler
			 "match single atom name" %match-single-atom-name-handler
			 ))

	    (setf %continue t)
	    (send '("scroll through atoms" "start") T ...)
	    (%dispatch %map)
	    (if found
		(values found answer)
		(values nil nil)) ;; the variable answer remains unbound if lookup was unsuccessful ; don't use answer here in that case (else CL will throw and unbound-variable exception)
	)
    (funcall %lookup-1 name)))
