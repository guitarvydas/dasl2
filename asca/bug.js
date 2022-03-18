const OKgrammar = String.raw `
basictoken {
Main = Item+
Item = any
}

linenumbers <: basictoken {
  Main := Item+
}
`;

// not ok
const NOKgrammar = String.raw `
basictoken {
Item = any
}

linenumbers <: basictoken {
  Main = Item+
}
`;

const text = String.raw `
a
b
`;
const temptext = String.raw `
{"token":"ident","content":"def"},
{"token":"nl","content":"%0A"},
`;

var ohm = require ('ohm-js');

grammars = ohm.grammars (OKgrammar);
parser = grammars ["linenumbers"];
var cst = parser.match (text);
if (cst.succeeded ()) {
    console.log ('OK');
} else {
    console.log ('failed');
}

grammars = ohm.grammars (NOKgrammar);
parser = grammars ["linenumbers"];
var cst = parser.match (text);
if (cst.succeeded ()) {
    console.log ('OK');
} else {
    console.log ('failed');
}

