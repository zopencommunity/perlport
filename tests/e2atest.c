#include <iconv.h>
#include <stdio.h>

static char* e2ap = NULL;
static char e2at[256] = { 0 };
static char* e2a_init(void) {
      int i;
      size_t inleft;
      size_t outleft;
      int rc;
      iconv_t cd;
      char ascii[256];
      char ebcdic[256];
      char* inptr = ebcdic;
      char* outptr = ascii;

      for (i=0; i<sizeof(ebcdic); ++i) {
        ebcdic[i] = i;
      }
      if ((cd = iconv_open("ISO8859-1", "IBM-1047")) == (iconv_t)(-1)) {
        return NULL;
      }
      inleft = sizeof(ebcdic);
      outleft = sizeof(ascii);
      rc = iconv(cd, &inptr, &inleft, &outptr, &outleft);
      if (rc == -1 || (inleft != 0)) {
        return NULL;
      }
      iconv_close(cd);
      memcpy(e2at, ascii, sizeof(ascii));

      return e2at;
}

static size_t e2a(char* buffer) {
      if (buffer == NULL) {
	return -1;
      } 
      if (!e2ap) {
	e2ap = e2a_init(); /* safe race condition */
	if (!e2ap) {
          exit(8); /* hard error */
	}
      } 
      size_t len = strlen(buffer);
      int i;
      for (i=0; i<len; ++i) {
	buffer[i] = e2ap[buffer[i]];
      } 
      return len;
} 

int main() {
	char ebcdic_hi[] = { 0x88, 0x89, 0x00 };
	char ebcdic_bye[] = { 0x82, 0xa8, 0x85, 0x00 };

	e2a(ebcdic_hi);
	e2a(ebcdic_bye);

	printf("0x%x 0x%x %s %s\n", *((unsigned int*) ebcdic_hi), *((unsigned int *) ebcdic_bye), ebcdic_hi, ebcdic_bye);
	return 0;
}
