#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h> 
#include <string.h>

int main() 
{
    char str[50] = {0}, buffer[200];


    int fd = open("input.txt", O_RDONLY);
   
    int x1 = read(fd, str, sizeof(str) - 1);
    close(fd);

    str[x1] = '\0'; 
    
    int len = strlen(str);
    if (str[len - 1] == '\n')
     {
        str[len - 1] = '\0';
        len--;
    }
    
    for (int i = 0; str[i] != '\0'; i++)
        str[i] = toupper(str[i]);

    int fd1 = open("output.txt", O_WRONLY | O_CREAT | O_APPEND, 0644);
    
    snprintf(buffer, sizeof(buffer), "\t\t\tTASK: CAPITALIZE THE STRING | PID: %d | RESULT: %s\n", getpid(), str);
    write(fd1, buffer, strlen(buffer));

    close(fd1);
    return 0;
}

