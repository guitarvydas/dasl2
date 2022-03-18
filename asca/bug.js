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

const fatgrammar = String.raw `
basictoken {
// basic token
  //BasicMain = Token+
  Token = "{" dq "token" dq ":" string "," dq "content" dq ":" string "}" ","?
  string = dq stringChar* dq
  dq = "\""
  stringChar = ~dq any


}

linenumbers <: basictoken {

  Default = LineNumberingToken+

  LineNumberingToken = NLToken | Token
  NLToken = "{" dq "token" dq ":" dq "nl" dq "," dq "content" dq ":" string "}" ","?

}
`;

const text = String.raw `
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

