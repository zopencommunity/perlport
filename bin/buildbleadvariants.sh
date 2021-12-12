#!/bin/sh
#
# Run through the 8 'important' combinations to see how well everything does
#
. ./setenv.sh
export PERL_VRM="blead" 
cps="ascii ebcdic"
cps="ascii"
amodes="31 64"
links="static dynamic"
for cp in $cps; do
	export PERL_OS390_TGT_CODEPAGE="$cp"
	for amode in $amodes; do
		export PERL_OS390_TGT_AMODE="$amode" 
		for link in $links; do
			export PERL_OS390_TGT_LINK="$link"
			build="$PERL_VRM.$PERL_OS390_TGT_AMODE.$PERL_OS390_TGT_LINK.$PERL_OS390_TGT_CODEPAGE"
			echo "Build $build"
			perlbuild.sh
			rc=$?
			if [ $rc -gt 0 ]; then
				echo "Failed to build $build" >&2
			fi
			testout="/tmp/maketest.$build.out" 
			if [ -z "$testout" ]; then
				echo "Did not run full tests. Checking minitest" >&2
				testout="/tmp/makeminitest.$build.out"
				if [ "$PERL_OS390_TGT_CODEPAGE" = "ascii" ]; then
					chtag -t -cISO8859-1 $testout # msf temporary hack
				fi
			fi
			if [ -z "$testout" ]; then
				echo "Did not run full or mini tests" >&2
			else
				summary=`grep 'Failed' $testout  | grep 'tests out of'`
				echo "Summary: $summary"
			fi
		done
	done
done
