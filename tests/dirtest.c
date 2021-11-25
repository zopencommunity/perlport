/*
 * Compile as: c99 -qascii dirtest.c 
 * Works fine and indicates readdir is properly ASCII-enabled.
 * Note it doesn't work if you don't include stdio.h         
 */

#define _POSIX_SOURCE

#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <stdio.h>

main() {
DIR *dir;
struct dirent *entry;

if ((dir = opendir("./")) == NULL)
perror("opendir() error");
else {
puts("contents of root:");
while ((entry = readdir(dir)) != NULL)
printf(" %s\n", entry->d_name);
closedir(dir);
}
}
