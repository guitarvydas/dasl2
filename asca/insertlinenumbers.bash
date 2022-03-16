#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
${prep} '.' '$' asct.ohm asct.glue --stop=1 --support=${cdir}/support.js

