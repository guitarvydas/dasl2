#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' asct.ohm asct.glue --stop=1 --support=${cdir}/support.js

