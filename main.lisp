(defparameter *version* "0.1.0")
(defparameter *dir* (namestring (uiop:getcwd)))
(defparameter *delimiter* (uiop:directory-separator-for-host))
(defparameter *files* nil)
(defparameter *ignore-dirs* #(".git" "node_modules" "bin"))
(defparameter *ignore-files*
  (util:string-split (uiop:read-file-string "src/ignore/files.txt") #\newline))

(defun main ()
  (let* ((options (parse-cli-args))
         (include (getf options :include))
         (exclude (getf options :exclude))
         (dir (getf options :dir))
         (version? (getf options :version))
         (exact? (getf options :exact))
         (case-insensitive (getf options :case-insensitive)))
    (when version?
      (format t "Version: ~A" *version-number*)
      (exit))
    (when dir
      (unless (probe-file dir)
        (dir-not-found dir))
      (setf *dir* dir))
    (start-your-engines)))
;;   (when (getf options :dir)
;;     (setf *dir* (getf options :dir)))
;; ))

(defun check-for-changes ())

(defun start-your-engines ()
  (index-directory *dir*)
  (setf *input* (format nil "~A~C" *input* #\a))
  (check-for-changes)
  (setf *input* (format nil "~A~C" *input* #\r))
  (check-for-changes)
  )

(defun dir-not-found (dir-name)
  (throw-error (format nil "directory \"~A\" does not exist" dir-name)))

(defun throw-error (error-message)
  (format t "Error: ~A" error-message)
  (exit))
