#!/bin/sh
#
# Set up environment variables for general build tool to operate
#
if ! [ -f ./setenv.sh ]; then
  echo "Need to source from the setenv.sh directory" >&2
  return 0
fi

export PORT_ROOT="${PWD}"
export PORT_TYPE="GIT"
export PORT_CONFIGURE="./Configure"
export PORT_CONFIGURE_OPTS="-Dprefix=$install_dir -Duserelocatableinc -Dusedevel -des -Duse64bitall -Dusedl"
export PORT_CHECK_OPTS="test"
export PORT_GIT_URL="https://github.com/Perl/perl5.git"
export PORT_GIT_DEPS="git make"
export PORT_GIT_BRANCH="blead"

# Perl Environment variables
export INSTALLFLAGS="+v"
