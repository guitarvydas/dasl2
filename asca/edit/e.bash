#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`

#target=test2
target=grammar

# ${prep} '.' '$' edit1.ohm edit1.fmt --stop=1 <${target}.txt

echo running edit1
${prep} '.' '$' edit1.ohm edit1.fmt --stop=1 <${target}.txt >/tmp/${target}
echo running edit2
${prep} '.' '$' edit2.ohm edit2.fmt --stop=1 </tmp/${target}

