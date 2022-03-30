#!/bin/bash
pdir=~/quicklisp/local-projects/cl-sector-lispasc/
thisdir=~/quicklisp/local-projects/dasl2/asca/
echo
echo
echo
echo
echo ${pdir}
echo ${thisdir}
echo
echo
echo
echo
sed -E -e '/;.*$/d' -e '/\(etags /d' -e 's/[ 	]+/ /g' -e '/\(\$debug /d' <${pdir}/proto.lisp >/tmp/proto.lisp
sed -E -e '/\(nets /d' -e '/\(\$args /d' -e '/\(etags /d' -e 's/[ 	]+/ /g' <${thisdir}/lookupasc.lisp >/tmp/lookupasc.lisp
diff -E -b -w -B -W 160 -d -C 0 /tmp/proto.lisp /tmp/lookupasc.lisp
exit 0
