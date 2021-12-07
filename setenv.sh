#!/bin/sh
#set -x

if ! [ -f ./setenv.sh ]; then
	echo "Need to source from the setenv.sh directory" >&2
else
	export _BPXK_AUTOCVT="ON"
	export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG),POSIX(ON),TERMTHDACT(MSG)"
	export _TAG_REDIR_ERR="txt"
	export _TAG_REDIR_IN="txt"
	export _TAG_REDIR_OUT="txt"

	if [ "$HOME" != '' ] && [ -d $HOME/bin ]; then
		export PATH=$HOME/bin:/usr/local/bin:/bin:/usr/sbin
	else
		export PATH=/usr/local/bin:/bin:/usr/sbin
	fi  
	export LIBPATH=/lib:/usr/lib

	# See perlbuild.sh for valid values of PERL_xxx variables
	export PERL_VRM="blead" #maint-5.34|blead
	export PERL_OS390_TGT_AMODE="31" # 31|64
	export PERL_OS390_TGT_LINK="dynamic" # static|dynamic
	export PERL_OS390_TGT_CODEPAGE="ebcdic" # ebcdic|ascii

	export PERL_ROOT="${PWD}"
	export GIT_ROOT=/rsusr/ported/bin

	export PATH="${PERL_ROOT}/bin:$PATH"

	echo "Environment set up for ${PERL_VRM}.${PERL_OS390_TGT_AMODE}.${PERL_OS390_TGT_LINK}.${PERL_OS390_TGT_CODEPAGE}"
fi
