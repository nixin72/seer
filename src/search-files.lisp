(defparameter *matches* '())

(defmacro append! (list element)
  `(setf ,list (append ,list (list ,element))))

(defun search-for-initial-matches (filename search)
  "
  Given a beginning character, find all lines in the file that 
  contain that character.
  "
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          for linum from 1
          until (eq line nil) do
      (loop for char across line
            for col from 1 do
        (when (eq char search)
          (append! *matches* `(:file ,filename
                               :linum ,linum
                               :col ,col
                               :line ,line
                               :match))
        )))))

(defun search-files (search)
  (bst:in-order-traversal
   *files*
   #'(lambda (file)
       (search-for-initial-matches file search))))
