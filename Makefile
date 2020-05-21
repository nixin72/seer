build:
	sbcl --load seer.asd \
	     --eval "(ql:quickload :seer)" 			\
	     --eval "(sb-ext:save-lisp-and-die #p\"seer\"	\
			:executable t 				\
			:toplevel #'main)"
