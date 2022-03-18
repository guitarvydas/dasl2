#!/bin/bash
prep=~/tools/prep/prep
cdir=`pwd`
${prep} '.' '$' tokenize.ohm tokenize.glue --stop=1 --support=${cdir}/support.js

