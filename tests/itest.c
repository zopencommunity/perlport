#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>

    static int setccsid(int fd, int ccsid) {
      attrib_t attr;

      memset(&attr, 0, sizeof(attr));
      attr.att_filetagchg = 1;
      attr.att_filetag.ft_ccsid = ccsid;
      attr.att_filetag.ft_txtflag = 1;

      return __fchattr(fd, &attr, sizeof(attr));
    }
    static int fdtagged(int fd) {
      struct stat st;
      int rc = fstat(fd, &st);
      if (rc) {
        return 1;
      }
      return st.st_tag.ft_txtflag;
    }  

int main(int argc, char* argv[]) {
  char buf[1024];
  int tag;
  int fd;
  int ccsid;
  int rc;

  if (argc != 2) {
    fprintf(stderr, "syntax: itest <file> where <file> is the name of the file to read\n");
    return(16);
  }

  fd = open(argv[1], O_RDONLY);
  tag = fdtagged(fd);

  printf("tagged:%d\n", tag);
  if (!tag) { 
    if (!setccsid(fd, 1047)) {
        printf("Error. File still not tagged\n");
    } else {
      printf("file now tagged as: %d\n", ccsid);
    }
  } else {
    printf("file was already tagged\n");
    return 1;
  }
     
  rc = read(fd, buf, sizeof(buf)-1);
  if (rc <= 0) {
    printf("Error. Unable to read file\n");
  } else {
    puts(buf);
  }
  close(fd);
}
