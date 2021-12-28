#define _XOPEN_SOURCE_EXTENDED 1
#include <stdlib.h>

int main() {
  char template[256] = "XXXX";
  mkstemp(template);
}
