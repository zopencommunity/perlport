# perlport
Port of perl to z/OS

## Philosophy

This port is designed in such a way to:
 - make it clear what needs to be patched from the mainline perl code
 - work in ASCII wherever possible, for consistency with other modern language ports (e.g. Node.js, Golang)
 - alternately, support a _traditional_ mode of operation in EBCDIC with no file tagging
 - enable everyone to improve the code by doing development completely in the open

## How to build from source

Pre-requisites:
 - Git - It is recommended that you use git v2.14.4_zos_b09 from [Rocket Software](https://www.rocketsoftware.com/zos-open-source)'s 
   - perlport's scripts utilize the HTTPS protocol to clone git repos.  To use the HTTPS protocol, make sure that the following environment
     variables are set:
      - GIT_SSL_CAINFO=/path/to/cacerts.pem
      - GIT_TEMPLATE_DIR=/path/to/share/git-core/templates
      - GIT_EXEC_PATH=/path/to/libexec/git-core
 - GNU Make - It is recommended that you use [IBM Make for z/OS](https://www-01.ibm.com/marketing/iwm/platform/mrs/assets?source=swg-dmzos)
 - C compiler - It is recommended that you use either xlclang or c99 to build perl.  xlclang can be downloaded from https://www.ibm.com/products/z-and-cloud-modernization-stack

To build and test the code:
 - Log on to z/OS UNIX
 - Make sure that Git and GNU Make path's are in your PATH environment variable and configured appropriately.  Additionally, set the environment variable GIT_ROOT to the bin directory of your git installation: `export GIT_ROOT=/rsusr/ported/bin`
 - Clone perlport: `git clone https://github.com/ZOSOpenTools/perlport.git && cd perlport`
 - Source the perlport environment variables via setenv.sh: `. ./setenv.sh`
 - Set the perl install location to your preferred location.  `export PERL_OS390_TGT_CONFIG_OPTS="-Dprefix=$HOME/local"`
 - Now build, test and install perl: `perlbuild.sh`

The code is built by `perlbuild.sh`, which performs the following tasks:
 - cloning perl5 from the perl repo
 - setting the code page of the files to ISO8859-1 (ASCII)
 - applying the patches to the mainline perl code from the `patches` directory
 - running Configure
 - running make
 - running make test
 - running make install

## How to add an update

When a problem is uncovered, do the following:
 - Modify the code and then generate a `git diff`
 - Redirect the output of `git diff` to a uniquely named patch file under `patches/perl5` directory.  

## How to push changes

To propose a fix to the mainline to the perlport repo:
 - Request access to create a branch
 - Create a pull request for the change, with appropriate documentation describing the change
 - Notify one of the committers to do a review
