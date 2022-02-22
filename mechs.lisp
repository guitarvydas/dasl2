;;;;; formatting


(defun $format (address $env)
  (let ((s ($stringify address)))
    (let ((str (format nil "~a: ~a" address s)))
      (values str))))

(defun $stringify (address)
  (cond 
   (($null? address) "NIL")
   (($atom? address) ($stringify-atom address))
   (t ($stringify-list address))))

(defun $stringify-atom (address)
  (cond
   (($null? address) "")
   (t
    (assert ($atom? address))
    (format nil "~c~a" ($get address) ($stringify-atom ($cdr address))))))

(defun $stringify-list ($list)
  (format nil "(~{~a~^ ~})" ($stringify-list-internals $list)))

(defun $stringify-list-internals ($list)
  ;; return a Lisp list of strings, given a Sector Lisp list
  (cond
   (($null? $list) nil)
   (($atom? $list) (list (format nil ". ~a" ($stringify $list))))
   (t (cons
       (format nil "~a" ($stringify ($car $list)))
       ($stringify-list-internals ($cdr $list))))))
  
;;;
;; evaluator
;; import $constants
;; import $env
(defun @eval (e)
    (cond
      ((null? e) $NIL)
      ((atom? e) ($assoc e))
      (($eq ($car e) (kQuote $constants)) ($car ($cdr e)))
      (($eq ($car e) (kCond $constants)) ($evcon ($cdr e)))
      (t 
       (let ((args ($evlis ($cdr e) $env)))
         (let ((v ($apply ($car e) args $env)))
           v)
           )))))

;; import $constants
(defun $apply (f args env)
  ;; apply function f to a *list* of values (args) in given environment
  (cond

    (($list? f) 
     ;; we have ((...) (... exprs ...))
     ;; f is a list with the shape (lambda (args ...) (body ...))
     ;; the car of the cdr is (args ...)
     ;; the car of the cddr is (body ...)
     ;; the actual exprs that are to be bound to the args is args
     (let ((ignore-should-be-lambda ($car f))  ;; first
	   (arg-names ($car ($cdr f)))         ;; second
           (body      ($car ($cdr ($cdr f))))) ;; third
       (declare (ignore ignore-should-be-lambda))
       (let ((new-env ($pairlis arg-names args env)))
	 ($eval body new-env))))

    (($eq f (kEQ $constants))
     (let ((first-arg ($car args))
	   (second-arg ($car ($cdr args))))
       ($eq first-arg second-arg)))

    (($eq f (kCons $constants)
     (let ((first-arg ($car args))
	   (second-arg ($car ($cdr args))))
       ($cons first-arg second-arg)))

    (($eq f (kAtom $constants)
     (let ((first-arg ($car args)))
       ($atom? first-arg)))

    (($eq f (kCar $constants)
     (let ((first-arg ($car args)))
       ($car first-arg)))

    (($eq f (kCdr $constants)
     (let ((first-arg ($car args)))
       ($cdr first-arg)))

    (t
     (let ((lookup-function ($assoc f))) ;; find the value of f
       ($apply lookup-function args)))))


(defun $pairlis (arg-names vals env)
  ;; pair up each arg-name with a value
  (cond

    ((not ($null? arg-names))
     (let ((first-name ($car arg-names))
	   (first-value ($car vals))
	   (rest-of-names ($cdr arg-names))
	   (rest-of-values ($cdr vals)))
       (let ((pairing ($cons first-name first-value)))
	 ($cons pairing ($pairlis rest-of-names rest-of-values env)))))       

    (t env)))

;; import $env
(defun $assoc (name)
  ;; get value of "name" in environment
  ;; undefined: if "name" is not in the environment
  (let ((first-pairing ($car env))
	(rest-of-pairings ($cdr env)))
    (let ((first-name ($car first-pairing)))
      (cond
	(($address=? name first-name)
	 (let ((first-value ($cdr first-pairing)))
	   first-value))
	(t ($assoc name rest-of-pairings))))))

(defun $evlis (expr-list env)
  ;; expr-list is a list of expressions which will form the args to a function
  ;; eval each arg, return a list of eval()ed args
  (cond
    (($null? expr-list) $NIL)
    (t
     (let ((first-expr ($car expr-list))
	   (rest-of-exprs ($cdr expr-list)))
       (let ((first-value ($eval first-expr env)))
	 ($cons first-value ($evlis rest-of-exprs env)))))))

(defun $evcon (list-to-be-interpreted-as-a-condition env)
  ;; interpret a list as a COND
  ;; each item in list-... is a pair
  ;;   1. guard
  ;;   2. expr to be eval()ed if guard is true
  ;; stop after first true guard
  ;; undefined: if no guards are true
  (let ((first-pair ($car list-to-be-interpreted-as-a-condition))
	(rest-of-pairs ($cdr list-to-be-interpreted-as-a-condition)))
    (let ((guard ($car first-pair)))
      (let ((guard-value ($eval guard env)))
	(cond ((> guard-value $NIL)
	       (let ((expr ($car first-pair)))
		 (let ((expr-value ($eval expr env)))
		   expr-value)))
	      (t ($evcon rest-of-pairs env)))))))


;;;; Garbage Collection
;; if index is an atom, return index
;; else index is a Cons, deep-copy it and return the new Cons
;;  add offset to all Cdrs while deep-copying (offset makes the CDR point to the final location(s) of the copied cell(s))
(defun $copy (index m offset)
  (if (< index m)
      (let ((car-copy ($copy ($car index) m offset))
            (cdr-copy ($copy ($cdr index) m offset)))
        (+ offset ($cons car-copy cdr-copy)))
    index))

;;; function Gc(A, x) {
;;;   var C, B = cx;
;;;   x = Copy(x, A, A - B), C = cx;
;;;   while (C < B) Set(--A, Get(--B));
;;;   return cx = A, x;
;;; }
;;;
;;; ;;; unwind comma-exprs
;;; function Gc(A, x) {
;;;   var C;
;;;   var B = cx;
;;;   var x = Copy(x, A, A - B)
;;;   C = cx;
;;;   while (C < B) Set(--A, Get(--B));
;;;   cx = A;
;;;   return x;
;;; }
(defun $gc (A index)
  (let ((B *mru-list-pointer*))
    (let ((copied-cell-index ($copy index A (- A B))))
      (let ((C *mru-list-pointer*))  ;; *mru-list-pointer* is bumped(and offset) iff index is a list
        (let ((new-A ($move A B C)))
          (setf *mru-list-pointer* new-A)
          copied-cell-index)))))

(defun $move (A B C)
  ;; A is the previous stack (cell) pointer
  ;; B is the bottom of the new stuff
  ;; C is the top of the new stuff
  ;; Move new cells into slots above A, from bottom-up (to avoid overwriting new stuff)
  ;; stop when everything below C has been copied
  ;; basically: copy from B to A, bump A and B, until B has reached C
  ;; byte-by-byte copy
  ;; A >= B >= C
  (loop while (< C B)
        do (progn
             (decf A 1)
             (decf B 1)
             (let ((byte ($car B)))
               ($put A byte))))
  A)

;;;;

;;;;; printing


(defun $print (address)
  (let ((s ($stringify address)))
    (let ((str (format nil "~a: ~a" address s)))
      ($raw-print str))))

(defun $stringify (address)
  (cond 
   (($null? address) "NIL")
   (($atom? address) ($stringify-atom address))
   (t ($stringify-list address))))

(defun $stringify-atom (address)
  (cond
   (($null? address) "")
   (t
    (assert ($atom? address))
    (format nil "~c~a" ($get address) ($stringify-atom ($cdr address))))))

(defun $stringify-list ($list)
  (format nil "(~{~a~^ ~})" ($stringify-list-internals $list)))

(defun $stringify-list-internals ($list)
  ;; return a Lisp list of strings, given a Sector Lisp list
  (cond
   (($null? $list) nil)
   (($atom? $list) (list (format nil ". ~a" ($stringify $list))))
   (t (cons
       (format nil "~a" ($stringify ($car $list)))
       ($stringify-list-internals ($cdr $list))))))
  
(defun $raw-print (lisp-string)
  (format *standard-output* "~a~%" lisp-string))

(defun $print-string (lisp-string)
  ($raw-print lisp-string))
;;;

(defun list-cells ()
  (let ((i *mru-list-pointer*)
        (stop $NIL)
        (result nil))
    (loop
     (when (>= i stop) (return))
     (push ($get i) result)
     (incf i))
    (reverse result)))

(defun main0 ()
  (initialize-memory)
  ;; (quote A)
  (let ((index-A ($putatom '(#\A))))
    (let ((list-to-be-interpreted ($cons kQuote ($cons index-A $NIL))))
      (let ((result ($eval list-to-be-interpreted $NIL)))
	(format *standard-output* "~a~%" result)))))

(defun main1 ()
  (initialize-memory)
  (let ((index-G ($putatom '(#\G)))
        (index-H ($putatom '(#\H))))

    ;; (G H)
    (let ((listGH
           ($cons index-G 
                  ($cons index-H $NIL))))
      ($print listGH)
      (let ((quote-listGH ($cons kQuote ($cons listGH $NIL))))
        ($print quote-listGH)
        (let ((car-quote-listGH ($cons kCar ($cons quote-listGH $nil))))
          ($print car-quote-listGH)
          (let ((result ($eval car-quote-listGH $NIL)))
            ($print result)
            (format *standard-output* "LSP=~a~%memory: ~a~%list: ~a~%~a~%" *mru-list-pointer* *memory* (list-cells) result)))))))

(defun old-main ()
  (initialize-memory)
  (let ((index-G ($putatom '(#\G)))
        (index-H ($putatom '(#\H)))
        (index-I ($putatom '(#\I))))

    ;; (G H)
    (let ((listGH
           ($cons index-G 
                  ($cons index-H $NIL))))
      ($print listGH)
      (let ((quote-listGH ($cons kQuote ($cons listGH $NIL))))
        ($print quote-listGH)
        (let ((third ($cons kCdr ($cons quote-listGH $nil))))
          ($print third)
          (let ((quote-i-third ($cons
                                ($cons kQuote ($cons index-I $NIL))
                                ($cons third $NIL))))
            ($print quote-i-third)
            (let ((program ($cons kCons quote-i-third)))
              ($print program)
              (let ((result ($eval program $NIL)))
                ($print result)
                (format *standard-output* "LSP=~a~%memory: ~a~%list: ~a~%~a~%" *mru-list-pointer* *memory* (list-cells) result)))))))))

(defun main10 ()
  (initialize-memory)
  ;; (Quote A)
  (let ((mem (make-instance 'atom-memory :bytes *memory*)))
    (let ((program ($read "(QUOTE A)" mem)))
      (let ((result ($eval program $NIL)))
	(format *standard-output* "~a~%" result)
        ($print result)))))
  
(defun main11 ()
  (initialize-memory)
  (let ((mem (make-instance 'atom-memory :bytes *memory*)))
;;    (let ((program ($read "(CONS (QUOTE A) (QUOTE B))" mem)))
    (let ((program ($read "((LAMBDA (X) X) (CONS (QUOTE P) (QUOTE Q)))" mem)))
;;    (let ((program ($read "((LAMBDA (X) (QUOTE X)) (CONS (QUOTE A) (QUOTE B)))" mem)))
      (let ((result ($eval program $NIL)))
	(format *standard-output* "~%~%result ~a~%" result)
        ($print result)))))

(defun main ()
  (initialize-memory)
  (let ((mem (make-instance 'atom-memory :bytes *memory*)))
    (let ((program ($read "A" mem)))
      ($print program))
    (let ((program ($read "(B)" mem)))
      ($print program))
    (let ((program ($read "(C D)" mem)))
      ($print program))
    (let ((program ($read "(CONS (QUOTE E) (QUOTE F))" mem)))
      (let ((v ($eval program $NIL)))
        ($print v)))
    (let ((program ($read "((LAMBDA (X) X) (CONS (QUOTE G) (QUOTE H)))" mem)))
      (let ((v ($eval program $NIL)))
        ($print v)))
    (let ((program ($read "((LAMBDA (X) (QUOTE A)) (CONS (QUOTE I) (QUOTE J)))" mem)))
      (format *standard-output* "mru list pointer before eval ~a~%" *mru-list-pointer*)
      (let ((v ($eval program $NIL)))
      (format *standard-output* "mru list pointer after eval ~a~%" *mru-list-pointer*)
        ($print v)))
    ))

(defun main13 ()
  (initialize-memory)
  (let ((mem (make-instance 'atom-memory :bytes *memory*)))
    (let ((program ($read "((LAMBDA (X) (QUOTE A)) (CONS (QUOTE I) (QUOTE J)))" mem)))
      (format *standard-output* "mru list pointer before eval ~a~%" *mru-list-pointer*)
      (let ((v ($eval program $NIL)))
      (format *standard-output* "mru list pointer after eval ~a~%" *mru-list-pointer*)
        ($print v)))
    ))

