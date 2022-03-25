(defparameter *lookup*
`(
(name . "lookup")
(etags . ("name" "found" "answer" ))
($args . nil)
(inputs . ("name" ))
(outputs . ("found" "answer" ))
(nets . ("⇒₁" "⇒₂" "⇒₃" "⇒₄" "⇒₅" "⇒₆" "⇒₇" "⇒₈" ))
(locals . ("found" "answer" "name" ))initially"name"⤶"name""answer"⇐No"found"⇐NoInject"scroll through atoms""name""◦name"handler⎡•"found":"found"⇐?dataConclude•"answer":"answer"⇐?data⎦finallyReturn"found""answer"children〔self〕λ"lookup""scroll through atoms""scroll through atoms""match single atom name""match single atom name""unsuccessful""unsuccessful""successful""successful"connections〔self〕"name""⇒₁""scroll through atoms""name""scroll through atoms""EOF""⇒₂""unsuccessful""conclude""scroll through atoms""try 1 name match""⇒₃""match single atom name""go""match single atom name""mismatch""⇒₄""scroll through atoms""advance""match single atom name""ok""⇒₅""successful""conclude""unsuccessful""found""⇒₆""self""found""successful""found""⇒₇""self""found""successful""answer""⇒₈""self""answer"))
,(defparameter *scroll-through-atoms*
`(
(name . "scroll through atoms")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
($args . nil)
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))
(nets . ())
(locals . ())initially"atom-memory"⤶"atom-memory"[@"atom-memory"."eof?"()|Yes:Send"EOF"No|No:Pass]handler"atom-memory"⥀"atom-memory"⎡•"name":Send"try 1 name match"TriggerConclude•"advance":"atom-memory"."advanceToNextAtom"()[@"atom-memory"."eof?"()|Yes:Send"EOF"No|No:Send"try 1 name match"Trigger]⎦finallychildrenconnections))
,(defparameter *match-single-atom-name*
`(
(name . "match single atom name")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
($args . nil)
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))
(nets . ())
(locals . ())initiallyhandler⎡•"go":[@""match string ""()|Yes:Send"ok"Trigger|No:Send"mismatch"Trigger]⎦finallychildrenconnections))
,(defparameter *unsuccessful*
`(
(name . "unsuccessful")
(etags . ("conclude" "found" ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" ))
(nets . ())
(locals . ())initiallyhandler⎡•"conclude":Send"found"No⎦finallychildrenconnections))
,(defparameter *successful*
`(
(name . "successful")
(etags . ("conclude" "found" "answer" ))
($args . nil)
(inputs . ("conclude" ))
(outputs . ("found" "answer" ))
(nets . ())
(locals . ())initiallyhandler⎡•"conclude":Send"answer"?dataSend"found"Yes⎦finallychildrenconnections))

(defparameter *lookup-signature*
(name . "lookup")
(etags . ("name" "found" "answer" ))
(inputs . ("name" ))
(outputs . ("found" "answer" ))),
(defparameter *scroll-through-atoms-signature*
(name . "scroll through atoms")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))),
(defparameter *match-single-atom-name-signature*
(name . "match single atom name")
(etags . ("name" "advance" "EOF" "try 1 name match" ))
(inputs . ("name" "advance" ))
(outputs . ("EOF" "try 1 name match" ))),
(defparameter *unsuccessful-signature*
(name . "unsuccessful")
(etags . ("conclude" "found" ))
(inputs . ("conclude" ))
(outputs . ("found" ))),
(defparameter *successful-signature*
(name . "successful")
(etags . ("conclude" "found" "answer" ))
(inputs . ("conclude" ))
(outputs . ("found" "answer" )))
