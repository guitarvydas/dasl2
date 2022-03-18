#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' tokenize.ohm tokenize.glue --stop=1 --support=${cdir}/support.js

