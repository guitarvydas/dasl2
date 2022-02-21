
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

