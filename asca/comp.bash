#!/bin/bash
# tr '\n' ' ' <out.lisp >temp.out.lisp
# tr '\n' ' ' <../lisp/lookup.proto.lisp >temp.lookup.proto.lisp
sed -E -e '/;.*$/d' -e '/\(etags /d' -e 's/[ 	]+/ /g' <../lisp/lookup.proto.lisp >temp.lookup.proto.lisp
sed -E -e '/\(nets /d' -e '/\(\$args /d' -e '/\(etags /d' -e 's/[ 	]+/ /g' <out.lisp >temp.out.lisp
diff -w -B -d temp.out.lisp temp.lookup.proto.lisp
exit 0

