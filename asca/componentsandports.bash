#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
${prep} '.' '$' asct.ohm componentsandports.glue --stop=1 --support=${cdir}/support.js

