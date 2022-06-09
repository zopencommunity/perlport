#!/bin/sh
# perl should have less than 22 failurs
# Determine number of failures by looking at "Failed.*tests out of" line
#
chk="$2_check.log"

set -x
failures=$(grep "Failed.*tests out of" ${chk} | cut -f2 -d' ')
if [ ${failures} -gt 21 ]; then
  exit 1
else
  exit 0
fi
