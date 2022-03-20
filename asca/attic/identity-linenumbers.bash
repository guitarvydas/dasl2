#!/bin/bash
prep=~/tools/pre/pre
cdir=`pwd`
${prep} '.' '$' linenumbers.ohm identity-linenumbers.glue --stop=1 --grammarname=linenumbers

