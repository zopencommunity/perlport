#!/bin/sh
INSTALL_DIR="$1"

cat <<EOF > ${INSTALL_DIR}/.env
if ! [ -f ./.env ]; then
  echo "Need to source from the .env directory" >&2
  return 0
fi
export _BPXK_AUTOCVT=ON
export _CEE_RUNOPTS="\$_CEE_RUNOPTS FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN=txt
export _TAG_REDIR_ERR=txt
export _TAG_REDIR_OUT=txt
mydir="\${PWD}"
export PATH="\${mydir}/bin:\$PATH"
for libperl in \$(find \${mydir} -name "libperl.so"); do
  libperl=\$(dirname "\${libperl}")
  export LIBPATH="\${libperl}:\$LIBPATH"
done
if ls \${mydir}/lib/perl[0-9]* >/dev/null 2>&1; then
  PERL5LIB_ROOT=\$( cd \${mydir}/lib/perl[0-9]/[0-9]*; echo \$PWD )
else
  PERL5LIB_ROOT=\$( cd \${mydir}/lib/[0-9]*; echo \$PWD )
fi
export PERL5LIB="\${PERL5LIB_ROOT}:\${PERL5LIB_ROOT}/os390"
EOF

exit 0
