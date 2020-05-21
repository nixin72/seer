(defun get-last-dir-in-path (path)
  (let* ((path-name (namestring path))
	 (len-1 (- (length path-name) 1))
	 (last-index (search (string *delimiter*)
			     path-name
			     :from-end t
			     :end2 len-1)))
    (subseq path-name (1+ last-index) len-1)))

(defun index-directory (dir)
  (let ((files (uiop:directory-files dir))
	(subdirs (uiop:subdirectories dir)))
    (setf *files* (concatenate 'vector *files* files))
    (when subdirs
      (loop for dir in subdirs 
	    when (not (find (get-last-dir-in-path dir)
			    *ignore*
			    :test #'string=)) do
	(index-directory dir)))))
