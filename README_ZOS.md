# z/OS Perl

# System Requirements
- z/OS V2R1 and above
- z196 and above
  - z/OS UNIX with Enhanced ASCII activated

# How to use:
- Set environment variables
  - Set PERL_INSTALL_DIR to the perl install directory
  - Then, source the `.env` file: 
```sh
. $PERL_INSTALL_DIR/.env
```
- Run `perl --version` to verify that the correct version is installed
- Run a Perl "Hello World" program:
- Create a `hello.perl` file with the following contents:
```perl
print("Hello, World!\n");
```
- Run `perl hello.perl`

