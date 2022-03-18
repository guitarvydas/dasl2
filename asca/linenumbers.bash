#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' linenumbers.ohm linenumbers.glue --stop=1 --support=${cdir}/support.js

