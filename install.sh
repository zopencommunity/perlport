#!/bin/sh

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"

# Add full path of installation directory to the PATH environment variable and create script to set environment variables required for Node.js
cat <<EOF > ${INSTALL_DIR}/.env
export _BPXK_AUTOCVT=ON
export _CEE_RUNOPTS="\$_CEE_RUNOPTS FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=txt
export _TAG_REDIR_ERR=txt
export _TAG_REDIR_OUT=txt
export PATH="${PERL_INSTALL_DIR}/bin:$PATH"
export PERL5LIB="${PERL_INSTALL_DIR}/lib"
for libperl in `find ${PERL_INSTALL_DIR}. -name "libperl.so"`; do
  libperl=$(dirname "${libperl}")
  export LIBPATH="${libperl}:$LIBPATH"
done
EOF

