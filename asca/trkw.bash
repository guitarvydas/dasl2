#!/bin/bash
sed -E \
    -e '/"content":"self"/s/"token":"ident"/"token":"self"/' \
    -e '/"content":"name"/s/"token":"ident"/"token":"name"/' \
    -e '/"content":"def"/s/"token":"ident"/"token":"def"/' \
    -e '/"content":"signature"/s/"token":"ident"/"token":"signature"/' \
    -e '/"content":"etags"/s/"token":"ident"/"token":"etags"/' \
    -e '/"content":"inputs"/s/"token":"ident"/"token":"inputs"/' \
    -e '/"content":"outputs"/s/"token":"ident"/"token":"outputs"/' \
    -e '/"content":"nets"/s/"token":"ident"/"token":"net"/' \
    -e '/"content":"locals"/s/"token":"ident"/"token":"locals"/' \
    -e '/"content":"initially"/s/"token":"ident"/"token":"initially"/' \
    -e '/"content":"handler"/s/"token":"ident"/"token":"handler"/' \
    -e '/"content":"finally"/s/"token":"ident"/"token":"finally"/' \
    -e '/"content":"children"/s/"token":"ident"/"token":"children"/' \
    -e '/"content":"connections"/s/"token":"ident"/"token":"connections"/' \
                          {"token":"ident","content":"Yes"},
         "content":"Yes"},
    -e '/"content":"Yes"/s/"token":"ident"/"token":"Yes"/' \
    -e '/"content":"No"/s/"token":"ident"/"token":"No"/' \
    -e '/"content":"Nil"/s/"token":"ident"/"token":"Nil"/' \
    -e '/"content":"Inject"/s/"token":"ident"/"token":"Inject"/' \
    -e '/"content":"Send"/s/"token":"ident"/"token":"Send"/' \
    -e '/"content":"Conclude"/s/"token":"ident"/"token":"Conclude"/' \
    -e '/"content":"Args"/s/"token":"ident"/"token":"Args"/' \
    -e '/"content":"\?data"/s/"token":"ident"/"token":"messageData"/' \
    -e '/"content":"\?tag"/s/"token":"ident"/"token":"messageETag"/'
