# from https://docs.python.org/3.3/tutorial/inputoutput.html#methods-of-file-objects

import sys
import re
def printkw (tag, line):
    print ('{"token":"compound","tag":"keyword"}, ', end="")
    print ('{"token":"keyword","tag":"' + tag + '"}, ', end="")
    print (line,end="")
for line in sys.stdin:
    if (re.search (r'"content":"Yes"',line)):
        printkw ("yes", line)
    elif (re.search (r'"content":"No"',line)):
        printkw ("no", line)
    elif (re.search (r'"content":"%E2%88%9E"',line)):
        printkw ("lookup", line)

    elif (re.search (r'"content":"Nil"',line)):
        printkw ("nil", line)
    elif (re.search (r'"content":"Trigger"',line)):
        printkw ("trigger", line)
    elif (re.search (r'"content":"Conclude"',line)):
        printkw ("conclude", line)
    elif (re.search (r'"content":"Args"',line)):
        printkw ("args", line)
    elif (re.search (r'"content":"Return"',line)):
        printkw ("return", line)
    elif (re.search (r'"content":"Send"',line)):
        printkw ("send", line)
    elif (re.search (r'"content":"Inject"',line)):
        printkw ("inject", line)
    elif (re.search (r'"content":"%3Fdata"',line)):
        printkw ("messagedata", line)
    elif (re.search (r'"content":"%3Fetag"',line)):
        printkw ("messageetag", line)
    else:
        print (line, end="")
