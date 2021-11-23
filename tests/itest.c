#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>

int chgfdccsid(int fd, int ccsid) {
  attrib_t attr;
  memset(&attr, 0, sizeof(attr));
  attr.att_filetagchg = 1;
  attr.att_filetag.ft_ccsid = ccsid;
  attr.att_filetag.ft_txtflag = 1;
  return __fchattr(fd, &attr, sizeof(attr));
}

int fdccsid(int fd, int *tag) {
  struct stat st;
  int rc;
  rc = fstat(fd, &st);
  if (rc != 0) {
    return -1;
  }
  unsigned short ccsid = st.st_tag.ft_ccsid;
  if (st.st_tag.ft_txtflag) {
    *tag = 1;
  } else {
    *tag = 0;
  }
  return ccsid;
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
  ccsid = fdccsid(fd, &tag);
  if (!tag) {
    printf("file not tagged\n");
  } else {
    printf("file is tagged as: %d\n", ccsid);
  }
  if (!chgfdccsid(fd, 1047)) {
    ccsid = fdccsid(fd, &tag);
    if (!tag) {
      printf("Error. File still not tagged\n");
    } else {
      printf("file now tagged as: %d\n", ccsid);
    }
  }
     
  rc = read(fd, buf, sizeof(buf)-1);
  if (rc <= 0) {
    printf("Error. Unable to read file\n");
  } else {
    puts(buf);
  }
  close(fd);
}
