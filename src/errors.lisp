(defun dir-not-found (dir-name)
  (throw-error (format nil "directory \"~A\" does not exist" dir-name)))

(defun unknown-cli-arg (cli-arg)
  (throw-error (format nil "argument \"~A\" is not valid" cli-arg)))

(defun throw-error (error-message)
  (format t "Error: ~A" error-message)
  (exit))
