(defun string-split (string &optional (delimiter #\Space))
  (loop for i = 0 then (1+ j)
	as j = (position delimiter string :start i)
	collect (subseq string i j)
	while j))

(setf *posix-argv* '("sbcl" "--include=.git" "--dir=/s/repos/seer"))
(defun parse-cli-args ()
  (let ((args (or #+CLISP *args*
		  #+SBCL *posix-argv*
		  #+LISPWORKS system:*line-arguments-list*
		  #+CMU extensions:*command-line-words*))
	(options '()))
    (loop for arg in args do
      (ignore-errors
       (cond ((search "--include=" arg :end2 10)
	      (setf (getf options :include)
		    (string-split (subseq arg 10) #\,)))
	     ((search "--exclude=" arg :end2 10)
	      (setf (getf options :exclude)
		    (string-split (subseq arg 10) #\,)))
	     ((search "--dir=" arg :end2 6)
	      (setf (getf options :dir) (format nil *dir* (subseq arg 6))))
	     ((search "--version" arg :end2 9)
	      (setf (getf options :version) t))
	     ((search "-e" arg)
	      (setf (getf options :exact) t))
	     ((search "-i" arg)
	      (setf (getf options :case-insensitive) t))
	     (t (unknown-cli-arg arg)))))
    options))
