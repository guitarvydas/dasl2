# from https://docs.python.org/3.3/tutorial/inputoutput.html#methods-of-file-objects

import sys
import re
def printkw (tag, line):
    print ('{"token":"compound","tag":"keyword"}, ', end="")
    print ('{"token":"keyword","tag":"' + tag + '"}, ', end="")
    print (line,end="")
for line in sys.stdin:
    if (re.search (r'"token":"ident".+"content":"Yes"',line)):
        printkw ("yes", line)
    elif (re.search (r'"token":"ident".+"content":"No"',line)):
        printkw ("no", line)

    elif (re.search (r'"token":"ident".+"content":"Nil"',line)):
        printkw ("nil", line)
    elif (re.search (r'"token":"ident".+"content":"Trigger"',line)):
        printkw ("trigger", line)
    elif (re.search (r'"token":"ident".+"content":"Conclude"',line)):
        printkw ("conclude", line)
    elif (re.search (r'"token":"ident".+"content":"Args"',line)):
        printkw ("args", line)
    elif (re.search (r'"token":"ident".+"content":"Return"',line)):
        printkw ("return", line)
    elif (re.search (r'"token":"ident".+"content":"Send"',line)):
        printkw ("send", line)
    elif (re.search (r'"token":"ident".+"content":"Inject"',line)):
        printkw ("inject", line)
    elif (re.search (r'"token":"ident".+"content":"%3Fdata"',line)):
        printkw ("messagedata", line)
    elif (re.search (r'"token":"ident".+"content":"%3Fetag"',line)):
        printkw ("messageetag", line)
    elif (re.search (r'"token":"ident".+"content":"connections"',line)):
        printkw ("connections", line)

    elif (re.search (r'"token":"lex".+"content":"%E2%88%9E"',line)):
        printkw ("lookup", line)
    elif (re.search (r'"token":"lex".+"content":"%CE%BB"',line)):
        printkw ("lambda", line)
    elif (re.search (r'"token":"lex".+"content":"."',line)):
        printkw ("dot", line)
    elif (re.search (r'"token":"lex".+"content":"\("',line)):
        printkw ("lpar", line)
    elif (re.search (r'"token":"lex".+"content":"\)"',line)):
        printkw ("rpar", line)
    elif (re.search (r'"token":"lex".+"content":"%5B"',line)):
        printkw ("lbracket", line)
    elif (re.search (r'"token":"lex".+"content":"%5D"',line)):
        printkw ("rbracket", line)
    elif (re.search (r'"token":"lex".+"content":"%C2%AB"',line)):
        printkw ("lport", line)
    elif (re.search (r'"token":"lex".+"content":"%C2%BB"',line)):
        printkw ("rport", line)

# |=??????
    elif (re.search (r'"token":"lex".+"content":""',line)):
        printkw ("choice", line)
    elif (re.search (r'"token":"lex".+"content":""',line)):
        printkw ("synonym", line)
    elif (re.search (r'"token":"lex".+"content":""',line)):
        printkw ("langle", line)
    elif (re.search (r'"token":"lex".+"content":""',line)):
        printkw ("rangle", line)

    elif (re.search (r'"token":"ident".+"content":"def"',line)):
        printkw ("def", line)
    elif (re.search (r'"token":"ident".+"content":"etags"',line)):
        printkw ("etags", line)
    elif (re.search (r'"token":"ident".+"content":"name"',line)):
        printkw ("name", line)
    elif (re.search (r'"token":"ident".+"content":"signature"',line)):
        printkw ("signature", line)
    elif (re.search (r'"token":"ident".+"content":"inputs"',line)):
        printkw ("inputs", line)
    elif (re.search (r'"token":"ident".+"content":"outputs"',line)):
        printkw ("outputs", line)
    elif (re.search (r'"token":"ident".+"content":"nets"',line)):
        printkw ("nets", line)
    elif (re.search (r'"token":"ident".+"content":"locals"',line)):
        printkw ("locals", line)
    elif (re.search (r'"token":"ident".+"content":"initially"',line)):
        printkw ("initially", line)
    elif (re.search (r'"token":"ident".+"content":"handler"',line)):
        printkw ("handler", line)
    elif (re.search (r'"token":"ident".+"content":"finally"',line)):
        printkw ("finally", line)
    elif (re.search (r'"token":"ident".+"content":"children"',line)):
        printkw ("children", line)

    else:
        print (line, end="")
