#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>


int main()
 {
    char str[50]={0},buffer[100];
    int fd = open("input.txt", O_RDONLY);
    int x1=read(fd, str, sizeof(str)-1);
    close(fd);

    str[x1] = '\0';

    int len = strlen(str);
     if (str[len - 1] == '\n') 
	{
	     str[len - 1] = '\0';
	     len--;
	}
    for (int i = 0; i < len/2; i++)
    {
    char temp=str[i];
    str[i]=str[len-i-1];
    str[len-i-1]=temp;
    }
    str[len] = '\0';

    int fd1 = open("output.txt", O_WRONLY | O_CREAT | O_APPEND, 0666);
    snprintf(buffer,sizeof(buffer), "\t\t\tTASK: REVERSE | PID: %d | RESULT: %s\n", getpid(), str);
    write(fd1, buffer, strlen(buffer));
    close(fd1);

    return 0;
}

