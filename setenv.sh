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

	export PERL_VRM="maint-5.34"
	export PERL_VRM="blead"
	export PERL_ROOT="${PWD}"
	export GIT_ROOT=/rsusr/ported/bin
fi
