#!/bin/sh
#
# Apply patches
# To create a new patch:
# cd to perl5 directory
# copy original file in perl5 directory to: <file>.orig
# diff -C 2 -f <file>.c <file>.orig >../patches/<file>.patch
#
if [ $# -ne 1 ]; then
	echo "Syntax: applypatches <root-dir>" >&2
	echo "  where <root-dir> is the root of the perlport tree" >&2
	exit 8
fi

PERLPORT_ROOT="$1"

if [ "${PERL_ROOT}" = '' ]; then
	echo "Need to set PERL_ROOT - source setenv.sh" >&2
	exit 16
fi
if [ "${PERL_VRM}" = '' ]; then
	echo "Need to set PERL_VRM - source setenv.sh" >&2
        exit 16
fi

if [ "${PERL_VRM}" = "maint-5.34" ]; then
	files="doio.c iperlsys.h hints/os390.sh cpan/Perl-OSType/lib/Perl/OSType.pm"

	for f in $files; do
		# Copy files to	'orig' version if not already copied
		# otherwise restore so that this step can be repeated

		CODE_ROOT="${PERLPORT_ROOT}/perl5"
		PATCH_ROOT="${PERLPORT_ROOT}/patches"
		if [ -f "${CODE_ROOT}/${f}.orig" ]; then
			# Restore
			cp "${CODE_ROOT}/${f}.orig" "${CODE_ROOT}/${f}"
		else
			# Backup	
			cp "${CODE_ROOT}/${f}" "${CODE_ROOT}/${f}.orig"
		fi

		patch -R -c "${CODE_ROOT}/${f}" <${PATCH_ROOT}/${f}.patch
		if [ $? -gt 0 ]; then
			echo "Patch of perl tree failed (${f})." >&2
			exit 16
		fi
	done
fi

exit 0	
