## README Patch Description

### cpan/Encode/Makefile.PL.patchascii 
 - The GNU make utility on z/OS is EBCDIC based and as such, is unable to process makefiles that have UTF8 
   characters in them. This patch removes the two Unicode characters. Longer term fix is to provide a 
   Bi-Modal ASCII GNU make on z/OS. This patch is only required for the ASCII build because the EBCDIC build
   has already modified the EBCDIC version of this file.

### cpan/Perl-OSType/lib/Perl/OSType.pm.patch 
 - The os390 build (i.e. z/OS) is not strictly EBCDIC. This patch changes os390 to be marked more accurately as Unix.

### ext/Errno/Errno_pm.PL.patch
 - The system headers on z/OS are in EBCDIC, but are untagged. The bi-modal build requires that files be tagged correctly
   so this patch copies the errno.h file (which may be mounted on a read-only file system) to a local file and then tags
   it as IBM-1047 (EBCDIC) so that it can be processed properly. The longer-term fix for this may be to have z/OS tag 
   header files as EBCDIC, although this would not be something Perl could rely on for several years.

### hints/os390.sh.patch
 - The Perl code expects that the ``environ`` global variable can be re-allocated to new storage and then have 
   entries added and removed from it. This isn't supported by z/OS when in Bi-Modal mode and so _PERL_USE_SAFE_PUTENV_
   macro is defined to use the _env_ services to manipulate ``environ`` instead of doing so directly. It is not clear
   if it is valid to re-allocate storage for the ``environ`` global variable or not, although it is worth pursuing 
   with the z/OS development team as a longer-term potential fix.

### Makefile.SH.patch
 - This change fixes a bug where the value of _use64bitall_ was expected to be nothing or something, but in fact,
   the proper test is for ``define|true|[yY]*``. 

## README.os390.patch
 - Rewrite of the readme file to bring it up to date and to document the various ways Perl can now be built and 
   used on z/OS.

## doio.c.patch
 - Provide an _asciiopen_ and _asciiopen3_ pair of functions for opening files on z/OS.
   These services do a standard open and then, if the open is successful, update the CCSID 
   of the file descriptor to 819 (ASCII) iff the oflag has ``O_CREAT`` set (e.g. a file is
   being created). We could consider printing out a warning if a file is untagged - right now
   this will _work correctly_ if the file in encoded as ASCII (CCSID 819) but will fail if the
   file is EBCDIC.                           
 - Provide a wrapper _Perl_mkstemp_cloexec_ which not only creates a temporary file using mkstemp
   but will also tag the file as CCSID 819. The tagging is only performed if ``__CHARSET_LIB == 1``, 
   i.e. the code is compiled with -qascii. 

## iperlsys.h.patch
 - Define _PerlIO_open_ and _PerlLIO_open3_ as _asciiopen_ and _asciiopen3_ respectively, when the code is
   built for ASCII ``#if (__CHARSET_LIB == 1)`` on z/OS ``#if defined(OEMVS)``.

## installperl.patch
 - Untag compiled executables (perl and the .so files) after they are copied with File::copy because
   File::copy is marking them as CCSID 819 (ASCII). The longer term fix for this could be to 
   provide a syscopy on z/OS which would perform a _cp_ which on z/OS copies the tag information as
   part of the copy.

## nostdio.h.patch 
 - Change this code to test for z/OS, not EBCDIC

## runtests.SH.patch
 - Change this code so that the unset of MAKEFLAGS is protected because, on z/OS, unset will return non-zero if
   the variable is not set and this then causes the shell to fail because it is being run with _-e_. This change
   is only required for z/OS but is harmless to have on all platforms.

## util.c.patch

 - Add code to change the file descriptor on the file descriptors opened from ``Perl_my_popen_list`` and ``Perl_my_popen`` so
   that the CCSID of the file descriptor is 819. This change is only when the code is
   built for ASCII ``#if (__CHARSET_LIB == 1)`` on z/OS ``#if defined(OEMVS)``.


