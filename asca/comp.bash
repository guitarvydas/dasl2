#!/bin/bash
# tr '\n' ' ' <out.lisp >temp.out.lisp
# tr '\n' ' ' <../lisp/lookup.proto.lisp >temp.lookup.proto.lisp
sed -E -e '/;.*$/d' -e '/\(etags /d' <../lisp/lookup.proto.lisp >temp.lookup.proto.lisp
sed -E -e '/\(nets /d' -e '/\(etags /d' <out.lisp >temp.out.lisp
diff -w temp.out.lisp temp.lookup.proto.lisp
exit 0

