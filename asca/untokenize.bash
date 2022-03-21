#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' asca.ohm untokenize.fmt --stop=1 --support=${cdir}/support.js --grammarname=untokenize

