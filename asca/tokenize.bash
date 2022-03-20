#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' tokenize.ohm tokenize.fmt --stop=1 --support=${cdir}/support.js

