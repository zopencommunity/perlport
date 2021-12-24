#define _POSIX_SOURCE

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/wait.h>

char buffer[100];
char *env_init[]={buffer, "TST2=goo", NULL};

int main(void)
{
        pid_t pid;

        if((pid==fork()) < 0 )
        {
                printf("fork() error");
                exit(1);
        }
        else if(pid==0)
        {

		sprintf(buffer, "%s=%s", "TST", "hoo");
                if(execle("/app/temp/perlport/tests/dumpvar", "dumpvar", "arg1", "arg2", (char*)0, env_init)<0)
                {
                        printf("execle() error");
                        exit(1);
                }
        }
        exit(0);
}
