#!/bin/sh
#set -x
output="/tmp/my.file"
rm -f "${output}"
../perl5/miniperl io.pl
rc=$?
if [ $rc -gt 0 ]; then
	echo "Test Failed. Expected rc of 0. Got $rc" >&2
	exit $rc
fi
#chtag -t -c ISO8859-1 "${output}"

actual=`cat ${output}`
expected="Hello World"
if [ "${actual}" != "${expected}" ]; then
	echo "Test Failed. Unexpected output. See file ${output} but expected: ${expected}" >&2
	exit 8
fi
exit 0
