#!/bin/sh

echo "Setting up Perl for z/OS"

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"

# Add full path of installation directory to the PATH environment variable and create script to set environment variables required 
cat <<EOF > ${INSTALL_DIR}/.env
export _BPXK_AUTOCVT=ON
export _CEE_RUNOPTS="\$_CEE_RUNOPTS FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=txt
export _TAG_REDIR_ERR=txt
export _TAG_REDIR_OUT=txt
export PATH="${INSTALL_DIR}/bin:\$PATH"
for libperl in \$(find ${INSTALL_DIR} -name "libperl.so"); do
  libperl=\$(dirname "\${libperl}")
  export LIBPATH="\${libperl}:\$LIBPATH"
done
if ls ${INSTALL_DIR}/lib/perl[0-9]* >/dev/null 2>&1; then
  PERL5LIB_ROOT=\$( cd ${INSTALL_DIR}/lib/perl[0-9]/[0-9]*; echo \$PWD )
else
  PERL5LIB_ROOT=\$( cd ${INSTALL_DIR}/lib/[0-9]*; echo \$PWD )
fi
export PERL5LIB="\${PERL5LIB_ROOT}:\${PERL5LIB_ROOT}/os390"
EOF

echo "Perl location: ${INSTALL_DIR}/bin/perl"
echo "\nIMPORTANT: Source the environment script prior to running perl using the dot (.) command:"
echo ". ${INSTALL_DIR}/.env"
