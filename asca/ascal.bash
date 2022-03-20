#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' asca.ohm ascal.fmt --stop=1 --support=${cdir}/support.js --grammarname=ascal

