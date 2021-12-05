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
if [ $# -ne 4 ]; then
	if [ "${PERL_VRM}" = "" ] || [ "${PERL_OS390_TGT_AMODE}" = "" ] || [ "{PERL_OS390_TGT_LINK}" = "" ] || [ "{PERL_OS390_TGT_CODEPAGE}" = "" ]; then
		echo "Either specify all 4 target build options on the command-line or with environment variables\n" >&2

		echo "Syntax: $0 [<vrm> <amode> <link> <codepage>]\n" >&2
		echo "  where:\n" >&2
		echo "  <vrm> is one of maint-5.34 or blead\n" >&2
		echo "  <amode> is one of 31 or 64\n" >&2
		echo "  <link> is one of static or dynamic\n" >&2
		echo "  <codepage> is one of ascii or ebcdic\n" >&2
		exit 16
	fi
else
	export PERL_VRM="$1"
	export PERL_OS390_TGT_AMODE="$2"
	export PERL_OS390_TGT_LINK="$3"
	export PERL_OS390_TGT_CODEPAGE="$4"
fi

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
	echo "You need GNU Make on your PATH in order to build Perl" >&2
	exit 16
fi

whence c99 >/dev/null
if [ $? -gt 0 ]; then
	echo "c99 required to build Perl. " >&2
	exit 16
fi

PERLPORT_ROOT="${PWD}"

perlbld="${PERL_VRM}.${PERL_OS390_TGT_AMODE}.${PERL_OS390_TGT_LINK}.${PERL_OS390_TGT_CODEPAGE}"

ConfigOpts="-Dprefix=/usr/local/perl/${perlbld}"
case "$PERL_VRM" in
	maint*) ConfigOpts="${ConfigOpts} -de" ;;
	blead) ConfigOpts="${ConfigOpts} -des -Dusedevel" ;;
	*) echo "Invalid PERL_VRM of: ${PERL_VRM} specified. Valid Options: [maint*|blead]\n" >&2; exit 16;;
esac
case "$PERL_OS390_TGT_AMODE" in
	31) ConfigOpts="${ConfigOpts}" ;;
	64) ConfigOpts="${ConfigOpts} -DUSE_64_BIT_ALL" ;;
	*) echo "Invalid PERL_OS390_TGT_AMODE of: ${PERL_OS390_TGT_AMODE} specified. Valid Options: [31|64]\n" >&2; exit 16;;
esac
case "$PERL_OS390_TGT_LINK" in
	static) ConfigOpts="${ConfigOpts}" ;;
	dynamic) ConfigOpts="${ConfigOpts} -Dusedl" ;;
	*) echo "Invalid PERL_OS390_TGT_LINK of: ${PERL_OS390_TGT_LINK} specified. Valid Options: [static|dynamic]\n" >&2; exit 16;;
esac
case "$PERL_OS390_TGT_CODEPAGE" in
	ascii) ConfigOpts="${ConfigOpts} -Dos390cp=ascii"; export os390cp='ascii' ;;
	ebcdic) ConfigOpts="${ConfigOpts} -Dos390cp=ebcdic" export os390cp='ebcdic' ;;
	*) echo "Invalid PERL_OS390_TGT_CODEPAGE of: ${PERL_OS390_TGT_CODEPAGE} specified. Valid Options: [ascii|ebcdic]\n" >&2; exit 16;;
esac

if [ -d "${PERLPORT_ROOT}/${perlbld}/perl5.local" ]; then
	rm -rf "${PERLPORT_ROOT}/${perlbld}/perl5"
	cp -rpf "${PERLPORT_ROOT}/${perlbld}/perl5.local" "${PERLPORT_ROOT}/${perlbld}/perl5"
elif ! [ -d "${PERLPORT_ROOT}/${perlbld}/perl5" ]; then
	mkdir -p "${PERLPORT_ROOT}/${perlbld}"
	echo "Clone Perl"
	date
	(cd "${PERLPORT_ROOT}/${perlbld}" && ${GIT_ROOT}/git clone https://github.com/Perl/perl5.git --branch "${PERL_VRM}" --single-branch --depth 1)

	if [ $? -gt 0 ]; then
		echo "Unable to clone Perl directory tree" >&2
		exit 16
	fi
	# This is not meant to be something we can do any development on, so
	# delete the git information

	rm -rf "${PERLPORT_ROOT}/${perlbld}/perl5/git_version.h" "${PERLPORT_ROOT}/${PERL_VRM}/perl5/.git*"
	chtag -R -h -t -cISO8859-1 "${PERLPORT_ROOT}/${perlbld}/perl5"

	if [ $? -gt 0 ]; then
		echo "Unable to tag Perl directory tree as ASCII" >&2
		exit 16
	fi
fi

managepatches.sh 
rc=$?
if [ $rc -gt 0 ]; then
	exit $rc
fi

cd "${perlbld}/perl5"
#
# Setup the configuration 
#
echo "Configure Perl"
date
export PATH=$PWD:$PATH
export LIBPATH=$PWD:$LIBPATH
nohup sh ./Configure ${ConfigOpts} >/tmp/config.${perlbld}.out 2>&1
if [ $? -gt 0 ]; then
	echo "Configure of Perl tree failed." >&2
	exit 16
fi

echo "Make Perl"
date

nohup make >/tmp/make.${perlbld}.out 2>&1
if [ $? -gt 0 ]; then
	echo "MAKE of Perl tree failed." >&2
	exit 16
fi

echo "Make Test Perl"
date

nohup make test >/tmp/maketest.${perlbld}.out 2>&1
if [ $? -gt 0 ]; then
	echo "MAKE Test of Perl tree failed." >&2
	exit 16
fi

date

exit 0
