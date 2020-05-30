(defpackage :util
  (:use :cl)
  (:export #:string-split
           #:file-size
           #:file=
           #:file<
           #:ignore-file-extensions
           #:file-extension
           ))

(in-package :util)

(defun string-split (string &optional (delimiter #\Space))
  (loop for i = 0 then (1+ j)
        as j = (position delimiter string :start i)
        collect (subseq string i j)
        while j))

(defun file-size (filename)
  (with-open-file (stream filename :direction :input :if-does-not-exist nil)
    (if stream (file-length stream) 0)))

(defun file= (file-1 file-2)
  "Checks if two files are of equal size using the format
  (:name #'path/to/file' :size size-of-file)
  "
  (eq (getf file-1 :size) (getf file-2 :size)))

(defun file< (file-1 file-2)
  "Checks if one file is smaller than the other using the format
  (:name #'path/to/file' :size size-of-file)
  "
  (< (getf file-1 :size) (getf file-2 :size)))

(defun ignore-file-extensions ()
  (let ((bst:*bst-copy-function* #'copy-seq)
        (bst:*bst-equal-p-function* #'string=)
        (bst:*bst-lesser-p-function* #'string<))
    (bst:bst-from-values
     (util:string-split
      (uiop:read-file-string #P"src/ignore/files.txt")
      #\newline))))

(defun file-extension (filename)
  (car (last (string-split filename #\.))))
