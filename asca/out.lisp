(defparameter *lookup*
`(

(name .  "lookup")
(etags . ())
(inputs . ())
(outputs . ())
(nets . ())
(locals . ())
(initially . ,(lambda ($context) 
 ($!local $context "answer" Nil)))
(handler . nil)
(finally . nil)
(children . ())
(connections . ())))

(defparameter *lookup-signature*
(name .  "lookup")
(etags . ())
(inputs . ())
(outputs . ()))
