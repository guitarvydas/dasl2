#!/bin/bash
prep=../tools/prep/prep
cdir=`pwd`
${prep} '.' '$' linenumbers.ohm identity-linenumbers.glue --stop=1

