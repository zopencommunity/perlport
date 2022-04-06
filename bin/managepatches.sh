#!/bin/sh
#
# Manage patches
# To create or refresh patch:
#   -perform a git diff of the affected files and redirect to a patch file
#
#set -x
if [ $# -ne 0 ]; then
	echo "Syntax: managepatches" >&2
	echo "  refreshes patch files" >&2
	exit 8
fi

# mydir="$(dirname $0)"

if [ "${PERL_ROOT}" = '' ]; then
	echo "Need to set PERL_ROOT - source setenv.sh" >&2
	exit 16
fi
if [ "${PERL_VRM}" = '' ]; then
	echo "Need to set PERL_VRM - source setenv.sh" >&2
        exit 16
fi

perlpatch="${PERL_VRM}"
perlcode="${PERL_VRM}.${PERL_OS390_TGT_AMODE}.${PERL_OS390_TGT_LINK}.${PERL_OS390_TGT_CODEPAGE}"

CODE_ROOT="${PERL_ROOT}/${perlcode}/perl5"
PATCH_ROOT="${PERL_ROOT}/${perlpatch}/patches"
commonpatches=`cd ${PATCH_ROOT} && find . -name "*.patch"`
specificpatches=`cd ${PATCH_ROOT} && find . -name "*.patch${PERL_OS390_TGT_CODEPAGE}"`
patches="$commonpatches $specificpatches"
results=`(cd ${CODE_ROOT} && ${GIT_ROOT}/git status --porcelain --untracked-files=no 2>&1)`
if [ "${results}" != '' ]; then
  echo "Existing Changes are active in ${CODE_ROOT}. To re-apply patches, perform a git reset on ${CODE_ROOT} prior to running managepatches again."
  exit 0	
fi 

failedcount=0
for patch in $patches; do
	p="${PATCH_ROOT}/${patch}"

	patchsize=`wc -c "${p}" | awk '{ print $1 }'` 
	if [ $patchsize -eq 0 ]; then
		echo "Warning: patch file ${p} is empty - nothing to be done" >&2 
	else 
		echo "Applying ${p}"
		out=`(cd ${CODE_ROOT} && ${GIT_ROOT}/git apply "${p}" 2>&1)`
		if [ $? -gt 0 ]; then
			echo "Patch of perl tree failed (${p})." >&2
			echo "${out}" >&2
			failedcount=$((failedcount+1))
		fi
	fi
done

exit $failedcount
