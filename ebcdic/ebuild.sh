#!/bin/sh
set -x
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
        rm -rf "${PERLPORT_ROOT}/perl5/git_version.h" "${PERLPORT_ROOT}/perl5/.git*"
        chtag -R -h -t -cISO8859-1 "${PERLPORT_ROOT}/perl5"
        if [ $? -gt 0 ]; then
        	echo "Unable to tag PERL directory tree as ASCII" >&2
        	exit 16
        fi
fi 

#
# copy patched up os390.sh hints to perform dynamic build
#
cp os390.sh.dynamic perl5/hints/os390.sh
cd perl5
nohup sh Configure -de -Dusedl >/tmp/config.ebcdic.out 2>&1
rc=$?
if [ $rc -gt 0 ]; then
  echo "Configure failed with rc:$rc." >&2
  exit 16
fi
nohup make >/tmp/make.ebcdic.out 2>&1
