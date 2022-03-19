#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' compoundidents.ohm compoundidents.glue --stop=1 --support=${cdir}/support.js --grammarname=compoundidents

