(defparameter *match-stack* '())

(defmacro append! (list element)
  `(setf ,list (append ,list (list ,element))))

(defun search-for-initial-matches (fileinfo search)
  " :: string -> character -> void
  Given a beginning character, find all lines in the file that 
  contain that character.
  "
  (let ((stack-top '()))
    (with-open-file (stream (getf fileinfo :name))
      (loop for line = (read-line stream nil)
            for linum from 1
            until (eq line nil) do
        (let ((match (loop for char across line
                           for col from 1
                           when (eq char search)
                           return `(:file ,(getf fileinfo :name)
                                    :linum ,linum
                                    :col ,col
                                    :line ,line
                                    ))))
          (when match
            (append! stack-top match)))))
    (append! *match-stack* stack-top)))

(defun fuzzy-search (new-char)
  (let ((stack-top '()))
    (loop for line in (car *match-stack*) do
      (let* ((start-col (getf line :col))
             (line-data (getf line :line))
             (match (loop for char across (subseq line-data start-col)
                          for col from start-col
                          when (eq char new-char)
                          return (set-values line :col col))))
        (when match
          (append! stack-top match))))
    (append! *match-stack* stack-top)))

(defparameter *ignore-files* (util:ignore-file-extensions))
(defun search-files (search)
  " :: character -> void
  Traverses through each file in the global *files* and 
  "
  (let ((bst:*bst-copy-function* #'copy-seq)
        (bst:*bst-equal-p-function* #'string=)
        (bst:*bst-lesser-p-function* #'string<))
    (bst:in-order-traversal 
      *files*
      #'(lambda (file)
          (unless (bst:bst-search
                   *ignore-files*
                   (util:file-extension (namestring (getf file :name))))
            (search-for-initial-matches file search))))))

(defun set-values (list &rest changed-values)
  (loop for (k nil) on changed-values
        when (keywordp k)
          do (setf (getf list k) (getf changed-values k)))
  list)
