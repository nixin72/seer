(defun get-last-dir-in-path (path)
  ":: pathname -> string

  Takes a pathname, such as #P\"/usr/share/bin/\" and returns the 
  last directory in that path name.

  Note: Only works on directories, files will break it.
  "
  (let* ((path-name (namestring path))
	 (len-1 (- (length path-name) 1))
	 (last-index (search (string *delimiter*)
			     path-name
			     :from-end t
			     :end2 len-1)))
    (subseq path-name (1+ last-index) len-1)))

(defun index-directory (dir)
  ":: string -> void

  Takes a directory and loops over all files and subdirectories.
    - Files are added to a BST sorted by size.
    - Directories are passed to this function in a recursive call.
  "
  (let ((files (uiop:directory-files dir))
        (subdirs (uiop:subdirectories dir))
        (bst:*bst-copy-function* #'copy-seq)
        (bst:*bst-equal-p-function* #'util:file=)
        (bst:*bst-lesser-p-function* #'util:file<))
    ; Add files to BST sorted by size
    (loop for file in files do
      (setf *files* (bst:bst-add! *files* `(:name ,file
                                            :size ,(util:file-size file)))))
    ; Loop through directories and call recursively
    (when subdirs
      (loop for dir in subdirs 
            when (not (find (get-last-dir-in-path dir)
                            *ignore-dirs*
                            :test #'string=)) do
        (index-directory dir)))))
