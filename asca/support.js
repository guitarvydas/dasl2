exports.encode = function (s) {
    return encodeURIComponent (s);
}

exports.decode = function (s) {
    return decodeURIComponent (s.replace (/"/g,""));
}

exports.decodeVerbatim = function (s) {
    return decodeURIComponent (s.replace (/◻/g,'').replace (/"/g,""));
}

let linenumber = 1;
exports.resetlinenumber = function () { linenumber = 1; }

exports.inclinenumber = function (str) {
    let n = (str.match (/%0A/g) || []).length;
    linenumber += n;
    return "";
}

exports.getlinenumber = function () {
    return linenumber.toString ();
}

exports.createToken = function (token, content) {
    return `{"token":"${token}", "content":${content}}`;
}

exports.mangle = function (s) {
    // let mangled = encodeURIComponent (s).replace (/%20/g," ");
    // return mangled;
    return s;
}

exports.makeLispName = function (s) {
    let name = s.trim ().replace (/"/g, "").trim ().replace (/ /g,'-');
    return name;
}

exports.formatContinuation = function (s) {
    if (s.trim ()) {
	return "\n" + s;
    } else {
	return "";
    }
}

let prototypeNameStack = [];
exports.pushPrototypeName = function (s) {
    prototypeNameStack.push (s);
}
exports.popPrototypeName = function () {
    prototypeNameStack.pop ();
    return "";
}
exports.getPrototypeName = function () {
    let name = prototypeNameStack.pop ();
    prototypeNameStack.push (name);
    return name;
}
let messageNameStack = [];
exports.pushMessageName = function (s) {
    messageNameStack.push (s);
}
exports.popMessageName = function () {
    messageNameStack.pop ();
    return "";
}
exports.getMessageName = function () {
    let name = messageNameStack.pop ();
    messageNameStack.push (name);
    return name;
}

