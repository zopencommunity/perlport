#define _XOPEN_SOURCE
#include <stdlib.h>
#include <stdio.h>
char** environ;
char** base;
int main() {
  int i;
  int entries=0;
  base = environ;
  while (environ[entries++]);
  for (i=0; i<entries; ++i) {
    printf("original environ[%d]=%s\n", i, environ[i]);
  }
  printf("entries:%d\n", entries);
  base = malloc(sizeof(char*)*(entries+1));
  for (i=0; i<=entries; ++i) {
    base[i] = environ[i];
  }  
  environ = malloc(sizeof(char*)*(entries+2));
  for (i=0; i<entries; ++i) {
    environ[i] = base[i];
  }  
  environ[entries-1] = "TST=foo";
  environ[entries] = ""; 
  environ[entries+1] = NULL; 
  for (i=0; i<entries+1; ++i) {
    printf("environ[%d]=%s\n", i, environ[i]);
  }
  system("./dumpvar");
}
