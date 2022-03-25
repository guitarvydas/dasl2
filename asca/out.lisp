(defparameter *〔lookup〕*
`(
(name . 〔lookup〕)
(etags . («name»«found»«answer»))
($args . nil)
(inputs . («name»))
(outputs . («found»«answer»))
(nets . ("⇒₁""⇒₂""⇒₃""⇒₄""⇒₅""⇒₆""⇒₇""⇒₈"))
(locals . ("found""answer""name"))initially"name"⤶"name""answer"⇐No"found"⇐NoInject〔scrollthroughatoms〕«name»"◦name"handler⎡•«found»:"found"⇐?dataConclude•«answer»:"answer"⇐?data⎦finallyReturn"found""answer"children〔self〕λ"lookup"〔scrollthroughatoms〕〔scrollthroughatoms〕〔matchsingleatomname〕〔matchsingleatomname〕〔unsuccessful〕〔unsuccessful〕〔successful〕〔successful〕connections〔self〕«name»"⇒₁"〔scrollthroughatoms〕«name»〔scrollthroughatoms〕«EOF»"⇒₂"〔unsuccessful〕«conclude»〔scrollthroughatoms〕«try1namematch»"⇒₃"〔matchsingleatomname〕«go»〔matchsingleatomname〕«mismatch»"⇒₄"〔scrollthroughatoms〕«advance»〔matchsingleatomname〕«ok»"⇒₅"〔successful〕«conclude»〔unsuccessful〕«found»"⇒₆"〔self〕«found»〔successful〕«found»"⇒₇"〔self〕«found»〔successful〕«answer»"⇒₈"〔self〕«answer»))
,(defparameter *〔scrollthroughatoms〕*
`(
(name . 〔scrollthroughatoms〕)
(etags . («name»«advance»«EOF»«try1namematch»))
($args . nil)
(inputs . («name»«advance»))
(outputs . («EOF»«try1namematch»))
(nets . ())
(locals . ())initially"atom-memory"⤶"atom-memory"[@"atom-memory"."eof?"()|Yes:Send«EOF»No|No:Pass]handler"atom-memory"⥀"atom-memory"⎡•«name»:Send«try1namematch»TriggerConclude•«advance»:"atom-memory"."advanceToNextAtom"()[@"atom-memory"."eof?"()|Yes:Send«EOF»No|No:Send«try1namematch»Trigger]⎦finallychildrenconnections))
,(defparameter *〔matchsingleatomname〕*
`(
(name . 〔matchsingleatomname〕)
(etags . («name»«advance»«EOF»«try1namematch»))
($args . nil)
(inputs . («name»«advance»))
(outputs . («EOF»«try1namematch»))
(nets . ())
(locals . ())initiallyhandler⎡•«go»:[@""match string ""()|Yes:Send«ok»Trigger|No:Send«mismatch»Trigger]⎦finallychildrenconnections))
,(defparameter *〔unsuccessful〕*
`(
(name . 〔unsuccessful〕)
(etags . («conclude»«found»))
($args . nil)
(inputs . («conclude»))
(outputs . («found»))
(nets . ())
(locals . ())initiallyhandler⎡•«conclude»:Send«found»No⎦finallychildrenconnections))
,(defparameter *〔successful〕*
`(
(name . 〔successful〕)
(etags . («conclude»«found»«answer»))
($args . nil)
(inputs . («conclude»))
(outputs . («found»«answer»))
(nets . ())
(locals . ())initiallyhandler⎡•«conclude»:Send«answer»?dataSend«found»Yes⎦finallychildrenconnections))

(defparameter *〔lookup〕-signature*
(name . 〔lookup〕)
(etags . («name»«found»«answer»))
(inputs . («name»))
(outputs . («found»«answer»))),
(defparameter *〔scrollthroughatoms〕-signature*
(name . 〔scrollthroughatoms〕)
(etags . («name»«advance»«EOF»«try1namematch»))
(inputs . («name»«advance»))
(outputs . («EOF»«try1namematch»))),
(defparameter *〔matchsingleatomname〕-signature*
(name . 〔matchsingleatomname〕)
(etags . («name»«advance»«EOF»«try1namematch»))
(inputs . («name»«advance»))
(outputs . («EOF»«try1namematch»))),
(defparameter *〔unsuccessful〕-signature*
(name . 〔unsuccessful〕)
(etags . («conclude»«found»))
(inputs . («conclude»))
(outputs . («found»))),
(defparameter *〔successful〕-signature*
(name . 〔successful〕)
(etags . («conclude»«found»«answer»))
(inputs . («conclude»))
(outputs . («found»«answer»)))
