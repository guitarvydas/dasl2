(defun top (NIL atom-space cons-space src out)
  (let ($conclude $parts $env
        %out
	($env (list ('NIL . NIL) ('atom-space . atom-space) ('cons-space . cons-space)
		   ('src . src) ('out . out))))
    (let (($conclude-predicate (lambda () $conclude))
	  ($not-concluded (lambda () (setf $conclude nil)))
          ($concluded (lambda () (setf $conclude t))))

      (let (
            ($self-handler (lambda ($message) 
                            (cond ((string= "out" ($message-tag $message))
                                   (setf %out ($message-data $message))
                                   ($concluded))
                                  (t (assert nil))
                                  )))
	    (%read-eval-format (lambda ($message)
				(cond ((string= "out" ($message-tag $message))
				       ($send '("read eval format" "out") ($message-data $message) $message $parts))
				      ((string= "$start" ($message-tag $message))
				       (%read-eval-format src out $env))
				      (t (assert nil)))))
	    ))

      (setf $parts (list
		   ;;  name handler input-queue output-queue locals
                   (list :self $self-handler nil nil nil)
                   (list "read eval format" read-eval-format nil nil nil)
                   ))
      
      (setf $connections '(
			  (("read eval format" "out") (:self "out"))
                          ))
      
      
      ;; main body
      ($not-concluded)
      ($send '("read eval format" "$start") t nil $parts)
      ($route-messages connections $parts $parts)
      ($dispatch parts connections $conclude-predicate)
      (values %out))))

(defun %read-eval-format (src buffer $env)
    (let (($conclude-predicate (lambda () $conclude))
	  ($not-concluded (lambda () (setf $conclude nil)))
          ($concluded (lambda () (setf $conclude t))))

      (let (
            ($self (lambda ($message $env) (%read-eval-format-$self-handler ($message $env))))
	    (%read (lambda ($message $env) (%read-handler $message $env)))
	    (%eval (lambda ($message $env) (%eval-handler $message $env)))
	    (%format (lambda ($message $env) (%format-handler $message $env)))
	    )
		     

        (let (($parts (list 
                       (list :self $self nil nil nil)
                       (list "read" %read nil nil nil)
                       (list "eval" %eval nil nil nil)
                       (list "format" %format nil nil nil)
                       ))
	      
              ($connections '(
			      (("read" "index") ("eval" "e"))
			      (("read" "atom space modified") (:self "atom space modified"))
			      (("eval" "result") ("format" "index"))
			      (("format" "result") (:self "formatted buffer"))
                              )))

	(let (($env `( (NIL . ,NIL) (atom-space . ,atom-space) (cons-space . ,cons-space)
		       (src . ,src) (out . ,out)
		       ($conclude . nil) (formatted-buffer . nil) (atom-space-modified . nil)
		       ($parts . ,$parts) ($connections . ,$connections))))
	  
	  ;; main body
	  ($not-concluded)
	  ($send '("format" "buffer") buffer $parts $env)
	  ($send '("read" "src") src $parts $env)
	  ($route-messages connections $parts $parts)
	  ($dispatch parts connections $conclude-predicate)
	  (values %formatted-buffer %atom-space-modified)))))

(defun %read-eval-format-$self-handler ($message $env) 
  (cond ((string= "formatted buffer" (message-tag $message))
         (setf %formatted-buffer (message-data $message))
         ($concluded))
	((string= "atom space modified" (message-tag $message))
	 (setf %atom-space-modified (message-data $message)))
        (t (assert nil))
        ))

(defun %read-handler ($message $env) 
  (cond ((string= "src" (message-tag $message))
	 (multiple-value-bind (index atom-space-modified)
	     (@read ($fetch 'src $env) $env))
	 (send '("read" "atom space modified") atom-space-modified $env)
	 (send '("read" "atom space modified") index $env))
	(t (assert nil))))
(defun %eval-handler ($message $env) 
  (cond ((string= "e" (message-tag $message))
	 (multiple-value-bind (result)
	     (@eval (message-data $message)))
	 (send '("eval" "result") result $env)
	(t (assert nil))))
(defun %format-handler ($message $env) 
  (cond ((string= "index" (message-tag $message))
	 (multiple-value-bind (formatted-buffer)
	     (@format (message-data $message) $env)
	   (send '("format" "formatted buffer") formatted-buffer $env)))
	((string= "buffer" (message-tag $message)) 
	 ($put '("format" "buffer") (message-data $message) $env))
	(t (assert nil))))
