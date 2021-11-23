#!/bin/sh
#set -x

# Test that files are created with an ASCII tag

output="/tmp/my.out"
rm -f "${output}"
../perl5/miniperl o.pl
rc=$?
if [ $rc -gt 0 ]; then
	echo "Test Failed. Expected rc of 0. Got $rc" >&2
	exit $rc
fi

actual=`cat ${output}`
expected="Hello World"
if [ "${actual}" != "${expected}" ]; then
	echo "Test Failed. Unexpected output. See file ${output} but expected: ${expected}" >&2
	exit 8
fi

# Test that untagged files are read in as EBCDIC
input="/tmp/my.in"
rm -f "${input}"
ls /bin/sh >"${input}"
#chtag -r "${input}"

actual=`../perl5/miniperl i.pl`
rc=$?
if [ $rc -gt 0 ]; then
	echo "Test Failed. Expected rc of 0. Got $rc" >&2
	exit $rc
fi

expected="/bin/sh"
if [ "${actual}" != "${expected}" ]; then
	echo "Test Failed. Unexpected input. See file ${input} but expected: ${expected}" >&2
	exit 8
fi

exit 0
