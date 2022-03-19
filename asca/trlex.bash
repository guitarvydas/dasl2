#!/bin/bash
sed -E \
    -e '/"content":"%E2%88%9E"/s/"token":"lex"/"token":"lookup"/' \
    -e '/"content":"%CE%BB"/s/"token":"lex"/"token":"lambda"/' \
    -e '/"content":"\."/s/"token":"lex"/"token":"dot"/' \
    -e '/"content":"\("/s/"token":"lex"/"token":"lpar"/' \
    -e '/"content":"\)"/s/"token":"lex"/"token":"rpar"/' \
    -e '/"content":"%5B"/s/"token":"lex"/"token":"lbracket"/' \
    -e '/"content":"%5D"/s/"token":"lex"/"token":"rbracket"/' \
    -e '/"content":"%C2%AB"/s/"token":"lex"/"token":"lport"/' \
    -e '/"content":"%C2%BB"/s/"token":"lex"/"token":"rport"/'
