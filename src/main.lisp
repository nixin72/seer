(ql:quickload :cl-readline)
(ql:quickload :uiop)

(defvar *dir* (uiop:getcwd))
(defvar *delimiter* (uiop:directory-separator-for-host))
(defvar *files* (make-array 0 :adjustable t))

(defparameter *ignore* #(".git" "node_modules" "bin"))

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

(defun event-handler ()
  (print "HERE"))

(defun terminate ()
  (exit))

(defun main ()
  (index-directory *dir*)
  (rl:register-hook :event #'event-handler)
  (rl:bind-keyseq "\\C-c" #'terminate)
  (rl:read-key))
