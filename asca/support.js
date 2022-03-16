exports.encode = function (s) {
    return encodeURIComponent (s);
}

let linenumber = 1;
exports.resetlinenumber = function () { linenumber = 1; }

exports.inclinenumber = function (str) {
    let n = (str.match (/%0A/g) || []).length;
    console.error (str);
    console.error (n);
    linenumber += n;
    return "";
}

exports.getlinenumber = function () {
    return linenumber.toString ();
}
