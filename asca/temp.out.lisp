(defparameter *lookup*
`(

(name .  "lookup")
(inputs . ())
(outputs . ())
(locals . ())
(initially . ,(lambda ($context) 
 ($!local $context "answer" Nil)))
(handler . nil)
(finally . nil)
(children . ())
(connections . ())))

(defparameter *lookup-signature*
(name .  "lookup")
(inputs . ())
(outputs . ()))
