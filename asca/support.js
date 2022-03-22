exports.encode = function (s) {
    return encodeURIComponent (s);
}

exports.decode = function (s) {
    return decodeURIComponent (s.replace (/"/g,""));
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
