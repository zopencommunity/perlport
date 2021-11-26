#!/bin/sh 
#set -x
#
# Pre-requisites: 
#  - cd to the directory of this script before running the script   
#  - ensure you have sourced setenv.sh, e.g. . ./setenv.sh
#  - ensure you have GNU make installed (4.1 or later)
#  - ensure you have access to c99
#  - network connectivity to pull git source from org
#
if [ "${PERL_ROOT}" = '' ]; then
	echo "Need to set PERL_ROOT - source setenv.sh" >&2
	exit 16
fi
if [ "${PERL_VRM}" = '' ]; then
	echo "Need to set PERL_VRM - source setenv.sh" >&2
	exit 16
fi

make --version >/dev/null 2>&1 
if [ $? -gt 0 ]; then
	echo "You need GNU Make on your PATH in order to build PERL" >&2
	exit 16
fi

whence c99 >/dev/null
if [ $? -gt 0 ]; then
	echo "c99 required to build PERL. " >&2
	exit 16
fi

PERLPORT_ROOT="${PWD}"
if ! [ -d perl5 ]; then
	${GIT_ROOT}/git clone https://github.com/Perl/perl5.git --branch "${PERL_VRM}" --single-branch --depth 1 
	if [ $? -gt 0 ]; then
		echo "Unable to clone PERL directory tree" >&2
		exit 16
	fi
	# This is not meant to be something we can do any development on, so
	# delete the git information
	rm -rf git_version.h .git*
	chtag -R -h -t -cISO8859-1 "${PERLPORT_ROOT}/perl5"
	if [ $? -gt 0 ]; then
		echo "Unable to tag PERL directory tree as ASCII" >&2
		exit 16
	fi
fi


./patches/managepatches.sh 
rc=$?
if [ $rc -gt 0 ]; then
	exit $rc
fi

cd perl5
#
# Setup the configuration 
#
sh Configure -de -Dusedl
if [ $? -gt 0 ]; then
	echo "Configure of PERL tree failed." >&2
	exit 16
fi

make
#make # hack - make twice
if [ $? -gt 0 ]; then
	echo "MAKE of PERL tree failed." >&2
	exit 16
fi


cd "${DELTA_ROOT}/tests"
export PATH="${PERL_ROOT}/${PERL_VRM}/src:${PATH}"

./runbasic.sh
if [ $? -gt 0 ]; then
	echo "Basic test of PERL failed." >&2
	exit 16
fi
./runexamples.sh
if [ $? -gt 0 ]; then
	echo "Example tests of PERL failed." >&2
	exit 16
fi
exit 0
