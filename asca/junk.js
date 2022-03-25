var xxx =
{

    Main : function (_x) { 
	_ruleEnter ("Main");

	var x = _x._glue ();
	var _result = `${x}`; 
	_ruleExit ("Main");
	return _result; 
    },
    
    ASCScript : function (_asc,_sig) { 
	_ruleEnter ("ASCScript");

	var asc = _asc._glue ();
	var sig = _sig._glue ();
	var _result = `${asc]${sig}`; 
	_ruleExit ("ASCScript");
	return _result; 
    },
    
    ASCComponent : function (_DefSection,_NameSection,_EtagsSection,_InputsSection,_OutputsSection,_NetsSection,_LocalsSection,_InitiallySection,_HandlerSection,_FinallySection,_ChildrenSection,_ConnectionsSection) { 
	_ruleEnter ("ASCComponent");
	support.pushPrototypeName (_DefSection._glue ()); 
	var DefSection = _DefSection._glue ();
	var NameSection = _NameSection._glue ();
	var EtagsSection = _EtagsSection._glue ();
	var InputsSection = _InputsSection._glue ();
	var OutputsSection = _OutputsSection._glue ();
	var NetsSection = _NetsSection._glue ();
	var LocalsSection = _LocalsSection._glue ();
	var InitiallySection = _InitiallySection._glue ();
	var HandlerSection = _HandlerSection._glue ();
	var FinallySection = _FinallySection._glue ();
	var ChildrenSection = _ChildrenSection._glue ();
	var ConnectionsSection = _ConnectionsSection._glue ();
	var _result = `(defparameter *${support.makeLispName (DefSection)}*\n\`(${NameSection}${EtagsSection}\n($args . nil)${InputsSection}${OutputsSection}${NetsSection}${LocalsSection}${InitiallySection}${HandlerSection}${FinallySection}${ChildrenSection}${ConnectionsSection}))\n${support.popPrototypeName ()}`; 
	_ruleExit ("ASCComponent");
	return _result; 
    },
    
    Signature : function (_Signature,_NameSection,_EtagsSection,_InputsSection,_OutputsSection) { 
	_ruleEnter ("Signature");

	var Signature = _Signature._glue ();
	var NameSection = _NameSection._glue ();
	var EtagsSection = _EtagsSection._glue ();
	var InputsSection = _InputsSection._glue ();
	var OutputsSection = _OutputsSection._glue ();
	var _result = `\n(defparameter *${support.makeLispName (Signature)}-signature*${NameSection}${EtagsSection}${InputsSection}${OutputsSection})`; 
	_ruleExit ("Signature");
	return _result; 
    },
    
    DefTopLevel : function (_kDef,_ComponentNameDef) { 
	_ruleEnter ("DefTopLevel");

	var kDef = _kDef._glue ();
	var ComponentNameDef = _ComponentNameDef._glue ();
	var _result = `${ComponentNameDef}`; 
	_ruleExit ("DefTopLevel");
	return _result; 
    },
    
    SignatureTopLevel : function (_kSig,_ComponentNameDef) { 
	_ruleEnter ("SignatureTopLevel");

	var kSig = _kSig._glue ();
	var ComponentNameDef = _ComponentNameDef._glue ();
	var _result = `${ComponentNameDef}`; 
	_ruleExit ("SignatureTopLevel");
	return _result; 
    },
    
    NameSection : function (_kwname,_ComponentName) { 
	_ruleEnter ("NameSection");

	var kwname = _kwname._glue ();
	var ComponentName = _ComponentName._glue ();
	var _result = `\n(name . ${ComponentName})`; 
	_ruleExit ("NameSection");
	return _result; 
    },
    
    EtagsSection : function (_kwetags,_TagNameDef) { 
	_ruleEnter ("EtagsSection");

	var kwetags = _kwetags._glue ();
	var TagNameDef = _TagNameDef._glue ().join ('');
	var _result = `\n(etags . (${TagNameDef}))`; 
	_ruleExit ("EtagsSection");
	return _result; 
    },
    
    InputsSection : function (_kwinputs,_TagName) { 
	_ruleEnter ("InputsSection");

	var kwinputs = _kwinputs._glue ();
	var TagName = _TagName._glue ().join ('');
	var _result = `\n(inputs . (${TagName}))`; 
	_ruleExit ("InputsSection");
	return _result; 
    },
    
    OutputsSection : function (_kwoutputs,_TagName) { 
	_ruleEnter ("OutputsSection");

	var kwoutputs = _kwoutputs._glue ();
	var TagName = _TagName._glue ().join ('');
	var _result = `\n(outputs . (${TagName}))`; 
	_ruleExit ("OutputsSection");
	return _result; 
    },
    
    NetsSection : function (_kwnets,_NetName) { 
	_ruleEnter ("NetsSection");

	var kwnets = _kwnets._glue ();
	var NetName = _NetName._glue ().join ('');
	var _result = `\n(nets . (${NetName}))`; 
	_ruleExit ("NetsSection");
	return _result; 
    },
    
    OwnSection : function (_kwown,_OwnName) { 
	_ruleEnter ("OwnSection");

	var kwown = _kwown._glue ();
	var OwnName = _OwnName._glue ().join ('');
	var _result = `\n(locals . (${OwnName}))`; 
	_ruleExit ("OwnSection");
	return _result; 
    },
    
    InitiallySection_op : function (_k,_op) { 
	_ruleEnter ("InitiallySection_op");

	var k = _k._glue ();
	var op = _op._glue ();
	var _result = `${k}${op}`; 
	_ruleExit ("InitiallySection_op");
	return _result; 
    },
    
    InitiallySection_empty : function (_k) { 
	_ruleEnter ("InitiallySection_empty");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("InitiallySection_empty");
	return _result; 
    },
    
    HandlerSection_op : function (_k,_op) { 
	_ruleEnter ("HandlerSection_op");

	var k = _k._glue ();
	var op = _op._glue ();
	var _result = `${k}${op}`; 
	_ruleExit ("HandlerSection_op");
	return _result; 
    },
    
    HandlerSection_empty : function (_k) { 
	_ruleEnter ("HandlerSection_empty");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("HandlerSection_empty");
	return _result; 
    },
    
    FinallySection_op : function (_k,_op) { 
	_ruleEnter ("FinallySection_op");

	var k = _k._glue ();
	var op = _op._glue ();
	var _result = `${k}${op}`; 
	_ruleExit ("FinallySection_op");
	return _result; 
    },
    
    FinallySection_empty : function (_k) { 
	_ruleEnter ("FinallySection_empty");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("FinallySection_empty");
	return _result; 
    },
    
    ChildrenSection_op : function (_k,_op) { 
	_ruleEnter ("ChildrenSection_op");

	var k = _k._glue ();
	var op = _op._glue ().join ('');
	var _result = `${k}${op}`; 
	_ruleExit ("ChildrenSection_op");
	return _result; 
    },
    
    ChildrenSection_empty : function (_k) { 
	_ruleEnter ("ChildrenSection_empty");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("ChildrenSection_empty");
	return _result; 
    },
    
    ConnectionsSection_op : function (_k,_op) { 
	_ruleEnter ("ConnectionsSection_op");

	var k = _k._glue ();
	var op = _op._glue ();
	var _result = `${k}${op}`; 
	_ruleExit ("ConnectionsSection_op");
	return _result; 
    },
    
    ConnectionsSection_empty : function (_k) { 
	_ruleEnter ("ConnectionsSection_empty");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("ConnectionsSection_empty");
	return _result; 
    },
    
    Operation_CreateAndSetTempFromArgs : function (_idleft,_kop,_idright,_op) { 
	_ruleEnter ("Operation_CreateAndSetTempFromArgs");

	var idleft = _idleft._glue ();
	var kop = _kop._glue ();
	var idright = _idright._glue ();
	var op = _op._glue ().join ('');
	var _result = `${idleft}${kop}${idright}${op}`; 
	_ruleExit ("Operation_CreateAndSetTempFromArgs");
	return _result; 
    },
    
    Operation_SetTempFromOwn : function (_idleft,_kop,_idright,_op) { 
	_ruleEnter ("Operation_SetTempFromOwn");

	var idleft = _idleft._glue ();
	var kop = _kop._glue ();
	var idright = _idright._glue ();
	var op = _op._glue ().join ('');
	var _result = `${idleft}${kop}${idright}${op}`; 
	_ruleExit ("Operation_SetTempFromOwn");
	return _result; 
    },
    
    Operation_SetOwnFromConstant : function (_idleft,_kop,_idright,_op) { 
	_ruleEnter ("Operation_SetOwnFromConstant");

	var idleft = _idleft._glue ();
	var kop = _kop._glue ();
	var idright = _idright._glue ();
	var op = _op._glue ().join ('');
	var _result = `${idleft}${kop}${idright}${op}`; 
	_ruleExit ("Operation_SetOwnFromConstant");
	return _result; 
    },
    
    Operation_InjectFromTemp : function (_kinject,_c,_p,_id,_op) { 
	_ruleEnter ("Operation_InjectFromTemp");

	var kinject = _kinject._glue ();
	var c = _c._glue ();
	var p = _p._glue ();
	var id = _id._glue ();
	var op = _op._glue ().join ('');
	var _result = `${kinject}${c}${p}${id}${op}`; 
	_ruleExit ("Operation_InjectFromTemp");
	return _result; 
    },
    
    Operation_SetOwnFromMessageData : function (_idleft,_kop,_idright,_op) { 
	_ruleEnter ("Operation_SetOwnFromMessageData");

	var idleft = _idleft._glue ();
	var kop = _kop._glue ();
	var idright = _idright._glue ();
	var op = _op._glue ().join ('');
	var _result = `${idleft}${kop}${idright}${op}`; 
	_ruleExit ("Operation_SetOwnFromMessageData");
	return _result; 
    },
    
    Operation_Conclude : function (_k,_op) { 
	_ruleEnter ("Operation_Conclude");

	var k = _k._glue ();
	var op = _op._glue ().join ('');
	var _result = `${k}${op}`; 
	_ruleExit ("Operation_Conclude");
	return _result; 
    },
    
    Operation_Pass : function (_k,_op) { 
	_ruleEnter ("Operation_Pass");

	var k = _k._glue ();
	var op = _op._glue ().join ('');
	var _result = `${k}${op}`; 
	_ruleExit ("Operation_Pass");
	return _result; 
    },
    
    Operation_ReturnOwnVariables : function (_k,_id,_op) { 
	_ruleEnter ("Operation_ReturnOwnVariables");

	var k = _k._glue ();
	var id = _id._glue ().join ('');
	var op = _op._glue ().join ('');
	var _result = `${k}${id}${op}`; 
	_ruleExit ("Operation_ReturnOwnVariables");
	return _result; 
    },
    
    Operation_SelfConnection : function (_k,_p,_n,_c,_p2,_op) { 
	_ruleEnter ("Operation_SelfConnection");

	var k = _k._glue ();
	var p = _p._glue ();
	var n = _n._glue ();
	var c = _c._glue ();
	var p2 = _p2._glue ();
	var op = _op._glue ().join ('');
	var _result = `${k}${p}${n}${c}${p2}${op}`; 
	_ruleExit ("Operation_SelfConnection");
	return _result; 
    },
    
    Operation_ChildConnection : function (_c1,_p1,_n,_c2,_p2,_op) { 
	_ruleEnter ("Operation_ChildConnection");

	var c1 = _c1._glue ();
	var p1 = _p1._glue ();
	var n = _n._glue ();
	var c2 = _c2._glue ();
	var p2 = _p2._glue ();
	var op = _op._glue ().join ('');
	var _result = `${c1}${p1}${n}${c2}${p2}${op}`; 
	_ruleExit ("Operation_ChildConnection");
	return _result; 
    },
    
    Operation_ChildToSelfConnection : function (_c1,_p1,_kself,_c2,_p2,_op) { 
	_ruleEnter ("Operation_ChildToSelfConnection");

	var c1 = _c1._glue ();
	var p1 = _p1._glue ();
	var kself = _kself._glue ();
	var c2 = _c2._glue ();
	var p2 = _p2._glue ();
	var op = _op._glue ().join ('');
	var _result = `${c1}${p1}${kself}${c2}${p2}${op}`; 
	_ruleExit ("Operation_ChildToSelfConnection");
	return _result; 
    },
    
    Operation_CallPredicateOfTempWithNoArgs : function (_id1,_kdot,_id2,_klp,_krp,_op) { 
	_ruleEnter ("Operation_CallPredicateOfTempWithNoArgs");

	var id1 = _id1._glue ();
	var kdot = _kdot._glue ();
	var id2 = _id2._glue ();
	var klp = _klp._glue ();
	var krp = _krp._glue ();
	var op = _op._glue ().join ('');
	var _result = `${id1}${kdot}${id2}${klp}${krp}${op}`; 
	_ruleExit ("Operation_CallPredicateOfTempWithNoArgs");
	return _result; 
    },
    
    Operation_SendConstant : function (_ksend,_p,_c,_op) { 
	_ruleEnter ("Operation_SendConstant");

	var ksend = _ksend._glue ();
	var p = _p._glue ();
	var c = _c._glue ();
	var op = _op._glue ().join ('');
	var _result = `${ksend}${p}${c}${op}`; 
	_ruleExit ("Operation_SendConstant");
	return _result; 
    },
    
    Operation_ConditionalMethod : function (_kleft,_kat,_id1,_kdot,_kid2,_klp,_krp,_op) { 
	_ruleEnter ("Operation_ConditionalMethod");

	var kleft = _kleft._glue ();
	var kat = _kat._glue ();
	var id1 = _id1._glue ();
	var kdot = _kdot._glue ();
	var kid2 = _kid2._glue ();
	var klp = _klp._glue ();
	var krp = _krp._glue ();
	var op = _op._glue ().join ('');
	var _result = `${kleft}${kat}${id1}${kdot}${kid2}${klp}${krp}${op}`; 
	_ruleExit ("Operation_ConditionalMethod");
	return _result; 
    },
    
    Operation_ConditionalFunction : function (_kleft,_kat,_id1,_klp,_krp,_op) { 
	_ruleEnter ("Operation_ConditionalFunction");

	var kleft = _kleft._glue ();
	var kat = _kat._glue ();
	var id1 = _id1._glue ();
	var klp = _klp._glue ();
	var krp = _krp._glue ();
	var op = _op._glue ().join ('');
	var _result = `${kleft}${kat}${id1}${klp}${krp}${op}`; 
	_ruleExit ("Operation_ConditionalFunction");
	return _result; 
    },
    
    Operation_CallExternalPredicateNoArgs : function (_kat,_id,_klp,_krp,_op) { 
	_ruleEnter ("Operation_CallExternalPredicateNoArgs");

	var kat = _kat._glue ();
	var id = _id._glue ();
	var klp = _klp._glue ();
	var krp = _krp._glue ();
	var op = _op._glue ().join ('');
	var _result = `${kat}${id}${klp}${krp}${op}`; 
	_ruleExit ("Operation_CallExternalPredicateNoArgs");
	return _result; 
    },
    
    Operation_SendMessageData : function (_ksend,_p,_kdata,_op) { 
	_ruleEnter ("Operation_SendMessageData");

	var ksend = _ksend._glue ();
	var p = _p._glue ();
	var kdata = _kdata._glue ();
	var op = _op._glue ().join ('');
	var _result = `${ksend}${p}${kdata}${op}`; 
	_ruleExit ("Operation_SendMessageData");
	return _result; 
    },
    
    Child : function (_c) { 
	_ruleEnter ("Child");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("Child");
	return _result; 
    },
    
    ChildSelfExternalFunction : function (_kself,_klambda,_id) { 
	_ruleEnter ("ChildSelfExternalFunction");

	var kself = _kself._glue ();
	var klambda = _klambda._glue ();
	var id = _id._glue ();
	var _result = `${kself}${klambda}${id}`; 
	_ruleExit ("ChildSelfExternalFunction");
	return _result; 
    },
    
    ChildComponent : function (_c1,_c2) { 
	_ruleEnter ("ChildComponent");

	var c1 = _c1._glue ();
	var c2 = _c2._glue ();
	var _result = `${c1}${c2}`; 
	_ruleExit ("ChildComponent");
	return _result; 
    },
    
    Handler : function (_op1,_left,_clause,_right,_op2) { 
	_ruleEnter ("Handler");

	var op1 = _op1._glue ().join ('');
	var left = _left._glue ();
	var clause = _clause._glue ().join ('');
	var right = _right._glue ();
	var op2 = _op2._glue ().join ('');
	var _result = `${op1}${left}${clause}${right}${op2}`; 
	_ruleExit ("Handler");
	return _result; 
    },
    
    CondClause : function (_k,_constant,_kcolon,_op) { 
	_ruleEnter ("CondClause");

	var k = _k._glue ();
	var constant = _constant._glue ();
	var kcolon = _kcolon._glue ();
	var op = _op._glue ();
	var _result = `${k}${constant}${kcolon}${op}`; 
	_ruleExit ("CondClause");
	return _result; 
    },
    
    HandlerClause : function (_k,_portname,_kcolon,_op) { 
	_ruleEnter ("HandlerClause");

	var k = _k._glue ();
	var portname = _portname._glue ();
	var kcolon = _kcolon._glue ();
	var op = _op._glue ();
	var _result = `${k}${portname}${kcolon}${op}`; 
	_ruleExit ("HandlerClause");
	return _result; 
    },
    
    Constant : function (_k) { 
	_ruleEnter ("Constant");

	var k = _k._glue ();
	var _result = `${k}`; 
	_ruleExit ("Constant");
	return _result; 
    },
    
    ComponentName : function (_left,_cs,_right) { 
	_ruleEnter ("ComponentName");

	var left = _left._glue ();
	var cs = _cs._glue ().join ('');
	var right = _right._glue ();
	var _result = `${left}${cs}${right}`; 
	_ruleExit ("ComponentName");
	return _result; 
    },
    
    PortName : function (_i) { 
	_ruleEnter ("PortName");

	var i = _i._glue ();
	var _result = `${i}`; 
	_ruleExit ("PortName");
	return _result; 
    },
    
    TagName : function (_left,_cs,_right) { 
	_ruleEnter ("TagName");

	var left = _left._glue ();
	var cs = _cs._glue ().join ('');
	var right = _right._glue ();
	var _result = `${left}${cs}${right}`; 
	_ruleExit ("TagName");
	return _result; 
    },
    
    NetName : function (_i) { 
	_ruleEnter ("NetName");

	var i = _i._glue ();
	var _result = `${i}`; 
	_ruleExit ("NetName");
	return _result; 
    },
    
    TempName : function (_i) { 
	_ruleEnter ("TempName");

	var i = _i._glue ();
	var _result = `${i}`; 
	_ruleExit ("TempName");
	return _result; 
    },
    
    keyword : function (_x) { 
	_ruleEnter ("keyword");

	var x = _x._glue ();
	var _result = `${x}`; 
	_ruleExit ("keyword");
	return _result; 
    },
    
    ExternalCode : function (_lb,_cs,_rb) { 
	_ruleEnter ("ExternalCode");

	var lb = _lb._glue ();
	var cs = _cs._glue ().join ('');
	var rb = _rb._glue ();
	var _result = `${lb}${cs}${rb}`; 
	_ruleExit ("ExternalCode");
	return _result; 
    },
    
    uriChar : function (_c) { 
	_ruleEnter ("uriChar");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("uriChar");
	return _result; 
    },
    
    identIncludingSpaces : function (_cs) { 
	_ruleEnter ("identIncludingSpaces");

	var cs = _cs._glue ().join ('');
	var _result = `"${support.mangle (cs)}"`; 
	_ruleExit ("identIncludingSpaces");
	return _result; 
    },
    
    identCharIncludingSpace : function (_c) { 
	_ruleEnter ("identCharIncludingSpace");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identCharIncludingSpace");
	return _result; 
    },
    
    ident_bracketed : function (_left,_compoundident,_right) { 
	_ruleEnter ("ident_bracketed");

	var left = _left._glue ();
	var compoundident = _compoundident._glue ();
	var right = _right._glue ();
	var _result = `"${support.mangle (compoundident)}"`; 
	_ruleExit ("ident_bracketed");
	return _result; 
    },
    
    ident_raw : function (_identfirst,_identrest) { 
	_ruleEnter ("ident_raw");

	var identfirst = _identfirst._glue ();
	var identrest = _identrest._glue ().join ('');
	var _result = `"${support.mangle (identfirst + identrest)}"`; 
	_ruleExit ("ident_raw");
	return _result; 
    },
    
    identFirst : function (_c) { 
	_ruleEnter ("identFirst");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identFirst");
	return _result; 
    },
    
    identRest : function (_c) { 
	_ruleEnter ("identRest");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identRest");
	return _result; 
    },
    
    identAny : function (_c) { 
	_ruleEnter ("identAny");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identAny");
	return _result; 
    },
    
    nl : function (_c) { 
	_ruleEnter ("nl");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("nl");
	return _result; 
    },
    
    separator : function (_c) { 
	_ruleEnter ("separator");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("separator");
	return _result; 
    },
    
    lineNumber : function (_left,_ds,_right) { 
	_ruleEnter ("lineNumber");

	var left = _left._glue ();
	var ds = _ds._glue ().join ('');
	var right = _right._glue ();
	var _result = `${left}${ds}${right}`; 
	_ruleExit ("lineNumber");
	return _result; 
    },
    
    space : function (_c) { 
	_ruleEnter ("space");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("space");
	return _result; 
    },
    
    Token : function (_t) { 
	_ruleEnter ("Token");

	var t = _t._glue ();
	var _result = `${t}`; 
	_ruleExit ("Token");
	return _result; 
    },
    
    GenericToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_s1,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("GenericToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var s1 = _s1._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${s1}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("GenericToken");
	return _result; 
    },
    
    NLToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_knl,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("NLToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var knl = _knl._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${knl}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("NLToken");
	return _result; 
    },
    
    WSToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kws,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("WSToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kws = _kws._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${kws}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("WSToken");
	return _result; 
    },
    
    LexToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_klex,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("LexToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var klex = _klex._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${klex}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("LexToken");
	return _result; 
    },
    
    TextToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_ktext,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("TextToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var ktext = _ktext._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${ktext}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("TextToken");
	return _result; 
    },
    
    IdentToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kident,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("IdentToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kident = _kident._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${kident}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("IdentToken");
	return _result; 
    },
    
    CompoundToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kcompound,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("CompoundToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kcompound = _kcompound._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${kcompoun}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("CompoundToken");
	return _result; 
    },
    
    EndCompoundToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kendcompound,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("EndCompoundToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kendcompound = _kendcompound._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${kendcompound}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("EndCompoundToken");
	return _result; 
    },
    
    string : function (_dq1,_cs,_dq2) { 
	_ruleEnter ("string");

	var dq1 = _dq1._glue ();
	var cs = _cs._glue ().join ('');
	var dq2 = _dq2._glue ();
	var _result = `${dq1}${cs}${dq2}`; 
	_ruleExit ("string");
	return _result; 
    },
    
    dq : function (_c) { 
	_ruleEnter ("dq");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("dq");
	return _result; 
    },
    
    stringChar : function (_c) { 
	_ruleEnter ("stringChar");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("stringChar");
	return _result; 
    },
    
    number : function (_ds) { 
	_ruleEnter ("number");

	var ds = _ds._glue ().join ('');
	var _result = `${ds}`; 
	_ruleExit ("number");
	return _result; 
    },
    
    LineToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kline,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_nn,_krb,_optcomma) { 
	_ruleEnter ("LineToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kline = _kline._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var nn = _nn._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${kline}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${nn}${krb}${optcomma}\n`; 
	_ruleExit ("LineToken");
	return _result; 
    },
    
    LportToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_klex,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_dq7,_s2,_dq8,_krb,_optcomma) { 
	_ruleEnter ("LportToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var klex = _klex._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var dq7 = _dq7._glue ();
	var s2 = _s2._glue ();
	var dq8 = _dq8._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${klex}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${dq7}${s2}${dq8}${krb}${optcomma}\n`; 
	_ruleExit ("LportToken");
	return _result; 
    },
    
    RportToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_klex,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_dq7,_s2,_dq8,_krb,_optcomma) { 
	_ruleEnter ("RportToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var klex = _klex._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var dq7 = _dq7._glue ();
	var s2 = _s2._glue ();
	var dq8 = _dq8._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${klex}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${dq7}${s2}${dq8}${krb}${optcomma}\n`; 
	_ruleExit ("RportToken");
	return _result; 
    },
    
    LbracketToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_klex,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_dq7,_s2,_dq8,_krb,_optcomma) { 
	_ruleEnter ("LbracketToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var klex = _klex._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var dq7 = _dq7._glue ();
	var s2 = _s2._glue ();
	var dq8 = _dq8._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${klex}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${dq7}${s2}${dq8}${krb}${optcomma}\n`; 
	_ruleExit ("LbracketToken");
	return _result; 
    },
    
    RbracketToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_klex,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_dq7,_s2,_dq8,_krb,_optcomma) { 
	_ruleEnter ("RbracketToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var klex = _klex._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var dq7 = _dq7._glue ();
	var s2 = _s2._glue ();
	var dq8 = _dq8._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${klex}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${dq7}${s2}${dq8}${krb}${optcomma}\n`; 
	_ruleExit ("RbracketToken");
	return _result; 
    },
    
    CompoundIdentToken : function (_t) { 
	_ruleEnter ("CompoundIdentToken");

	var t = _t._glue ();
	var _result = `${t}`; 
	_ruleExit ("CompoundIdentToken");
	return _result; 
    },
    
    Component : function (_lb,_compoundname,_rb) { 
	_ruleEnter ("Component");

	var lb = _lb._glue ();
	var compoundname = _compoundname._glue ().join ('');
	var rb = _rb._glue ();
	var _result = `${lb}${compoundname}${rb}`; 
	_ruleExit ("Component");
	return _result; 
    },
    
    Port : function (_lp,_compoundname,_rp) { 
	_ruleEnter ("Port");

	var lp = _lp._glue ();
	var compoundname = _compoundname._glue ().join ('');
	var rp = _rp._glue ();
	var _result = `${lp}${compoundname}${rp}`; 
	_ruleExit ("Port");
	return _result; 
    },
    
    CompoundName : function (_t) { 
	_ruleEnter ("CompoundName");

	var t = _t._glue ();
	var _result = `${t}`; 
	_ruleExit ("CompoundName");
	return _result; 
    },
    
    SubWSToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kws,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("SubWSToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kws = _kws._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}subident${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("SubWSToken");
	return _result; 
    },
    
    OldSubIdentToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_kident,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("OldSubIdentToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var kident = _kident._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}subident${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("OldSubIdentToken");
	return _result; 
    },
    
    SubIdentToken : function (_klb,_dq1,_ktoken,_dq2,_kcolon,_dq5,_ksubident,_dq6,_kcomma,_dq3,_kcontent,_dq4,_kcolon2,_s2,_krb,_optcomma) { 
	_ruleEnter ("SubIdentToken");

	var klb = _klb._glue ();
	var dq1 = _dq1._glue ();
	var ktoken = _ktoken._glue ();
	var dq2 = _dq2._glue ();
	var kcolon = _kcolon._glue ();
	var dq5 = _dq5._glue ();
	var ksubident = _ksubident._glue ();
	var dq6 = _dq6._glue ();
	var kcomma = _kcomma._glue ();
	var dq3 = _dq3._glue ();
	var kcontent = _kcontent._glue ();
	var dq4 = _dq4._glue ();
	var kcolon2 = _kcolon2._glue ();
	var s2 = _s2._glue ();
	var krb = _krb._glue ();
	var optcomma = _optcomma._glue ().join ('');
	var _result = `${klb}${dq1}${ktoken}${dq2}${kcolon}${dq5}${ksubident}${dq6}${kcomma}${dq3}${kcontent}${dq4}${kcolon2}${s2}${krb}${optcomma}\n`; 
	_ruleExit ("SubIdentToken");
	return _result; 
    },
    
    keyword : function (_x) { 
	_ruleEnter ("keyword");

	var x = _x._glue ();
	var _result = `${x}`; 
	_ruleExit ("keyword");
	return _result; 
    },
    
    ExternalCode : function (_lb,_cs,_rb) { 
	_ruleEnter ("ExternalCode");

	var lb = _lb._glue ();
	var cs = _cs._glue ().join ('');
	var rb = _rb._glue ();
	var _result = `${lb}${cs}${rb}`; 
	_ruleExit ("ExternalCode");
	return _result; 
    },
    
    uriChar : function (_c) { 
	_ruleEnter ("uriChar");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("uriChar");
	return _result; 
    },
    
    identIncludingSpaces : function (_cs) { 
	_ruleEnter ("identIncludingSpaces");

	var cs = _cs._glue ().join ('');
	var _result = `"${support.mangle (cs)}"`; 
	_ruleExit ("identIncludingSpaces");
	return _result; 
    },
    
    identCharIncludingSpace : function (_c) { 
	_ruleEnter ("identCharIncludingSpace");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identCharIncludingSpace");
	return _result; 
    },
    
    ident_bracketed : function (_left,_compoundident,_right) { 
	_ruleEnter ("ident_bracketed");

	var left = _left._glue ();
	var compoundident = _compoundident._glue ();
	var right = _right._glue ();
	var _result = `"${support.mangle (compoundident)}"`; 
	_ruleExit ("ident_bracketed");
	return _result; 
    },
    
    ident_raw : function (_identfirst,_identrest) { 
	_ruleEnter ("ident_raw");

	var identfirst = _identfirst._glue ();
	var identrest = _identrest._glue ().join ('');
	var _result = `"${support.mangle (identfirst + identrest)}"`; 
	_ruleExit ("ident_raw");
	return _result; 
    },
    
    identFirst : function (_c) { 
	_ruleEnter ("identFirst");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identFirst");
	return _result; 
    },
    
    identRest : function (_c) { 
	_ruleEnter ("identRest");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("identRest");
	return _result; 
    },
    
    nl : function (_c) { 
	_ruleEnter ("nl");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("nl");
	return _result; 
    },
    
    lineNumber : function (_left,_ds,_right) { 
	_ruleEnter ("lineNumber");

	var left = _left._glue ();
	var ds = _ds._glue ().join ('');
	var right = _right._glue ();
	var _result = `${left}${ds}${right}`; 
	_ruleExit ("lineNumber");
	return _result; 
    },
    
    space : function (_c) { 
	_ruleEnter ("space");

	var c = _c._glue ();
	var _result = `${c}`; 
	_ruleExit ("space");
	return _result; 
    },
    
    ReceiverRef : function (_component,_tag) { 
	_ruleEnter ("ReceiverRef");

	var component = _component._glue ();
	var tag = _tag._glue ();
	var _result = `'(${component} . ${tag})`; 
	_ruleExit ("ReceiverRef");
	return _result; 
    },
    
    _terminal: function () { return this.sourceString; },
    _iter: function (...children) { return children.map(c => c._glue ()); }
}

;

