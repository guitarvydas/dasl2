#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
${prep} '.' '$' linenumbers.ohm linenumbers.glue --stop=1 --support=${cdir}/support.js

