[![Automatic version updates](https://github.com/ZOSOpenTools/perlport/actions/workflows/bump.yml/badge.svg)](https://github.com/ZOSOpenTools/perlport/actions/workflows/bump.yml)

# perl
Place to share information about configure/build of perl for z/OS (only deltas to open source)

# pre-reqs
You need gnu make, xlclang, and curl to download and unzip a tarball or git to build from scratch. 
Detailed dependencies are in buildenv

You will also need a 'bootstrap' make to build.

To build, use zopen build from (https://github.com/ZOSOpenTools/utils) after setting up your environment, e.g.
```
. ./buildenv
zopen build
```

For details on the build, see (https://zosopentools.github.io/meta/#/Guides/Porting)

See expectedResults.txt for current failures
