#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' tokenize.ohm identity-tokenize.glue --stop=1

