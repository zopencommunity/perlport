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

	if [ -z "$GIT_ROOT" ]; then
		export GIT_ROOT=/rsusr/ported/bin
	fi  

	export PATH=$PWD/bin:$PATH

	# See perlbuild.sh for valid values of PERL_xxx variables
  if [ -z "${PERL_VRM}" ]; then
	  export PERL_VRM="blead" #maint-5.34|blead
  fi

  if [ -z "${PERL_OS390_TGT_AMODE}" ]; then
	  export PERL_OS390_TGT_AMODE="64" # 31|64
  fi

  if [ -z "${PERL_OS390_TGT_LINK}" ]; then
	  export PERL_OS390_TGT_LINK="dynamic" # static|dynamic
  fi

  if [ -z "${PERL_OS390_TGT_CODEPAGE}" ]; then
	  export PERL_OS390_TGT_CODEPAGE="ascii" # ebcdic|ascii
  fi

  if [ -z "${PERL_OS390_TGT_LOG_DIR}" ]; then
	  export PERL_OS390_TGT_LOG_DIR=${PWD} 
  fi

	export PERL_ROOT="${PWD}"

	export PATH="${PERL_ROOT}/bin:$PATH"

	export PERL_ENV="${PERL_ROOT}/${PERL_VRM}.${PERL_OS390_TGT_AMODE}.${PERL_OS390_TGT_LINK}.${PERL_OS390_TGT_CODEPAGE}/perl5"

	echo "Environment set up for ${PERL_ENV}"
fi
