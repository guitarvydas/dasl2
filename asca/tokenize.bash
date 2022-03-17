#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
${prep} '.' '$' tokenize.ohm tokenize.glue --stop=1 --support=${cdir}/support.js

