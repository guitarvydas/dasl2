(defsystem :lookup
  ;;:depends-on (:alexandria)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "macros" :depends-on ("package"))
                                     (:file "lookup.proto" :depends-on ("macros"))
                                     (:file "support" :depends-on ("macros"))
                                     (:file "lookup" :depends-on ("lookup.proto" "support"))))))

