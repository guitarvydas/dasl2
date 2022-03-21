#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`

target=test2

${prep} '.' '$' edit1.ohm edit1.fmt --stop=1 <${target}.txt

# ${prep} '.' '$' edit1.ohm edit1.fmt --stop=1 <${target}.txt >/tmp/${target}
# ${prep} '.' '$' edit2.ohm edit2.fmt --stop=1 </tmp/${target}

