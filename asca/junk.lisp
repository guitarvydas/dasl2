    (initially . 
               ,(lambda ($context) 
                  (let ((name ($?field ($?field $context '$args) 'name)))
                  
                    ($!local $context "answer" nil)
                    ($!local $context "found" nil)
                    ($inject '("scroll through atoms" . "name") name $context nil))))
