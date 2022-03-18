#!/bin/bash
prep=~/tools/prep/prep
cdir=`pwd`
${prep} '.' '$' linenumbers.ohm linenumbers.glue --stop=1 --support=${cdir}/support.js

