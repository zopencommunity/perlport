## README Patch Description

### cpan/Encode/Makefile.PL.patchascii 
 - The GNU make utility on z/OS is EBCDIC based and as such, is unable to process makefiles that have UTF8 
   characters in them. This patch removes the two Unicode characters. Longer term fix is to provide a 
   Bi-Modal ASCII GNU make on z/OS. This patch is only required for the ASCII build because the EBCDIC build
   has already modified the EBCDIC version of this file.

### ext/Errno/Errno_pm.PL.patch
 - The system headers on z/OS are in EBCDIC, but are untagged. The bi-modal build requires that files be tagged correctly
   so this patch copies the errno.h file (which may be mounted on a read-only file system) to a local file and then tags
   it as IBM-1047 (EBCDIC) so that it can be processed properly. The longer-term fix for this may be to have z/OS tag 
   header files as EBCDIC, although this would not be something Perl could rely on for several years.
