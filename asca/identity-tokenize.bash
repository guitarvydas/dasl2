#!/bin/bash
prep=~/tools/prep/prep
cdir=`pwd`
${prep} '.' '$' tokenize.ohm identity-tokenize.glue --stop=1

