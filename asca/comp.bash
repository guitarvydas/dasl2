#!/bin/bash
sed -E -e '/;.*$/d' -e '/\(etags /d' -e 's/[ 	]+/ /g' <../lisp/lookup.proto.lisp >temp.lookup.proto.lisp
sed -E -e '/\(nets /d' -e '/\(\$args /d' -e '/\(etags /d' -e 's/[ 	]+/ /g' <lookupasc.lisp >temp.lookupasc.lisp
diff -w -B -d temp.lookupasc.lisp temp.lookup.proto.lisp
exit 0

