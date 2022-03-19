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

const NOKtext = String.raw `ab`;
const OKtext = String.raw `a`;

var ohm = require ('ohm-js');

grammars = ohm.grammars (OKgrammar);
parser = grammars ["linenumbers"];
var cst = parser.match (NOKtext);
if (cst.succeeded ()) {
    console.log ('OK');
} else {
    console.log ('failed');
}

grammars = ohm.grammars (NOKgrammar);
parser = grammars ["linenumbers"];
var cst = parser.match (NOKtext);
if (cst.succeeded ()) {
    console.log ('OK');
} else {
    console.log ('failed');
}

