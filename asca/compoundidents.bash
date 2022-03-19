#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' asca.ohm compoundidents.fmt --stop=1 --support=${cdir}/support.js --grammarname=compoundidents

