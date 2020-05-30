(ql:quickload :asdf)

(asdf:defsystem :seer
  :author "Philip Dumaresq <phdumaresq@protonmail.com>"
  :license "MIT"
  :version "0.1"
  :source-control (:git "git@github.com:nixin72/seer.git")
  :depends-on (:cl-readline :uiop)
  :components
  ((:module "src"
    :serial t
    :components
    ((:module "lib"
      :serial t
      :components
      ((:file "bst")
       (:file "util")))
     (:file "errors")
     (:file "cli-args")
     (:file "index-project")
     (:file "search-files")))
   (:file "main")))
