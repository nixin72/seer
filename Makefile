build:
	sbcl --load seer.asd \
	     --eval "(sb-ext:save-lisp-and-die #p\"seer\"	\
			:executable t 				\
			:compression t  			\
			:toplevel #'seer:main)"
