#!/bin/sh
#
# Run through the 8 'important' combinations to see how well everything does
#
. ./setenv.sh
export PERL_VRM="blead" 
cps="ebcdic ascii"
amodes="64 31"
links="dynamic static" 

for amode in $amodes; do
	export PERL_OS390_TGT_AMODE="$amode" 
	for link in $links; do
		export PERL_OS390_TGT_LINK="$link"
		for cp in $cps; do
			export PERL_OS390_TGT_CODEPAGE="$cp"

			build="$PERL_VRM.$PERL_OS390_TGT_AMODE.$PERL_OS390_TGT_LINK.$PERL_OS390_TGT_CODEPAGE"
			echo "Build $build"
			perlbuild.sh
			rc=$?
			if [ $rc -gt 0 ]; then
				echo "Failed to build $build" >&2
			fi
			testout="/tmp/maketest.$build.out" 
			summary=`grep 'Failed' $testout  | grep 'tests out of'` 2>/dev/null
			if [ $? -gt 0 ]; then
				echo "Did not run full tests. Checking minitest" >&2
				testout="/tmp/makeminitest.$build.out"
				summary=`grep 'Failed' $testout  | grep 'tests out of'`
			fi
			echo "$build Summary: $summary"
		done
	done
done
