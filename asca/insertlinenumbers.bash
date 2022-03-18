#!/bin/bash
prep=~/tools/prep/prep
cdir=`pwd`
${prep} '.' '$' asct.ohm asct.glue --stop=1 --support=${cdir}/support.js

