#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
#${prep} '.' '$' ascatokenize.ohm identity-ascatokenize.glue --stop=1
${prep} '.' '$' ascatokenize.ohm ascatokenize.glue --stop=1 --support=${cdir}/support.js

