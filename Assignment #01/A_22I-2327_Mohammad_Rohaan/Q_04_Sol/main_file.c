#include<stdio.h>
#include<unistd.h>
#include<sys/wait.h>
#include<string.h>
#include<fcntl.h>
#include<stdlib.h>

int main()
{
	printf("\n\n\n\t\t\tSOLUTION OF PROBLEM# 04 => CHILD PROCESS (FORK CALLS)\n\n");
	char str[50],ch1;
	printf("\n\n\t\tEnter a string:     ");
	scanf("%s",str);
	int fd = open("input.txt", O_WRONLY | O_CREAT | O_TRUNC , 0644);
	write(fd,str,strlen(str));
	write(fd, "\n", 1); 
	close(fd);
	
         while (1)
         {
        printf("\n\n\t\tCHOOSE THE OPERATION:\n\n");
        printf("\t\t1. REVERSE THE STRING\n\n");
        printf("\t\t2. FIND LENGTH OF STRING\n\n");
        printf("\t\t3. INCREMENT OF 2 to ASCII\n\n");
        printf("\t\t4. SORT THE STRING\n\n");
        printf("\t\t5. CAPITALIZE\n\n");
        printf("\t\t6. EXIT FROM PROGRAM\n\n\t\t ENTER YOUR CHOICE HERE: ");
        scanf(" %c", &ch1);

        if (ch1 == '6')
	{
         break;
	}

        int pid = fork();
        
        
        if (pid == 0)
         {
          int child_pid = fork();
                    
          if (child_pid == 0)
           {  
                switch (ch1) 
            {
                case '1': 
                execlp("./reverse_str", "reverse_str", NULL); 
                break;
                case '2':
                execlp("./length_str", "length_str", NULL);
                break;
                case '3':
                execlp("./ascii_add_2_str", "ascii_add_2_str", NULL); 
                break;
                case '4': 
                execlp("./sort_str", "sort_str", NULL); 
                break;
                case '5': 
                execlp("./capitalize_str", "capitalize_str", NULL); 
                break;
                default: 
                printf("\n\n\t\tINVALID CHOICE.......!\n");
                sleep(2);
            }
            exit(0);
        }
        else
        {
        wait(NULL);
        exit(0);
        }
        
    }

   else {
            wait(NULL);  
        }
      
      }
      
    printf("\n\n\t\t\tFINAL OUTPUT ON TERMINAL FROM output.txt :\n\n");
    system("cat output.txt"); 
    printf("\n\n");
    return 0;
}
