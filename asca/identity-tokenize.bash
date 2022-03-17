#!/bin/bash
prep=../../dscript/tools/prep
cdir=`pwd`
${prep} '.' '$' tokenize.ohm identity-tokenize.glue --stop=1

