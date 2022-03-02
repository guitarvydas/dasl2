;;;;; printing


(defun $format (address)
  (let ((s ($stringify address)))
    (let ((str (format nil "~a: ~a" address s)))
      str)))

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
