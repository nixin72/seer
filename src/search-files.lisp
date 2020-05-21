(defparameter *matches* '(head))

(defmacro append! (list element)
  `(setf ,list (append ,list (list ,element))))

(defun search-for-initial-matches (filename search)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
	  for i from 1 do
      (loop for char across line do
	(when (eq char search)
	  (append *matches* `(:file ,filename :row i :line line :match))
	  )))))

(defmacro define (def body)
  `(defun ,(car def) ,(cdr def) ,body))
