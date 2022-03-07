# perlport
Port of perl to z/OS

## Philosophy

This port is designed in such a way to:
 - make it clear what needs to be patched from the mainline perl code
 - work in ASCII wherever possible, for consistency with other modern language ports (e.g. Node.js, Golang)
 - alternately, support a _traditional_ mode of operation in EBCDIC with no file tagging
 - enable everyone to improve the code by doing development completely in the open

## How to build from source

To build and test the code:
 - Log on to z/OS
 - git clone this repo
 - cd into the root directory
 - source setenv.sh: `. ./setenv.sh`
 - build and test: `./perlbuild.sh`

Start by using `miniperl` from the `perl5` directory to run simple tests

The code is built by:
 - cloning perl5 from the perl repo
 - setting the code page of the files to ISO8859-1 (ASCII)
 - applying the patches to the mainline perl code from the `patches` directory
 - running Configure
 - running make
 - running make test

## How to push changes

To propose a fix to the mainline to the perlport repo:
 - Request access to create a branch
 - Create a pull request for the change, with appropriate documentation describing the change
 - Notify one of the committers to do a review
