
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define BUFLEN 1024
#define MYFREE(x) free(x); x = NULL;

char const *ipcc;
char *statuss;
char *both_words;
char *s1;
char *s2;
char *results;
int m;
int charcount;

char * deblank(char *str)
{
    char *out = str, *put = str;
    
    for(; *str != '\0'; ++str)
    {
        if(*str != '\n' && *str != ',')
            *put++ = *str;
    }
    *put = '\0';
    
    return out;
}

char * search(char *both)
{
    char *c_to_search = "0packets";
    char *ma;
    int pos_search = 0;
    int pos_text = 0;
    int len_search = 4;
    int len_text = 67;
    
    for (pos_text = 0; pos_text < len_text - len_search;++pos_text)
    {
        
        if(both[pos_text] == c_to_search[pos_search])
        {
            ++pos_search;
            if(pos_search == len_search)
            {
                // match
                //printf("match from %d to %d\n",pos_text-len_search,pos_text);
                //printf("%s\n", "match");
                
                ma = "match";
            }
        }
        else
        {
            pos_text -=pos_search;
            pos_search = 0;
            
        }
 
    }
    return "true";
    
}

void concat()
{
    
    results = malloc(strlen(s1)+strlen(s2)+1);
    strcpy(results, s1);
    strcat(results, s2);
    
    both_words = results;

    return;
}

char* P(const char *ipAddr)
{
    int pipe_arr[2];
    char buf[BUFLEN];
    pipe(pipe_arr);
    
    if(fork() == 0)
    {
        dup2(pipe_arr[1], STDOUT_FILENO);
        execl("/sbin/ping", "ping", "-c 1", ipAddr, (char*)NULL);
    }
    else //parent
    {
        wait(NULL);
        read(pipe_arr[0], buf, BUFLEN);
        
        char *xxx = deblank(buf);
        
        
        //char *input = xxx;
        //char delimiter[] = " ";
        //char *firstWord, *secondWord, *thirdWord, *fourthWord, *a, *b, *c, *d, *e, *f, *g, *h, *i, *j, *remainder, *context;
        
        //int inputLength = strlen(input);
        
        //char *inputCopy = (char*) calloc(inputLength + 1, sizeof(char));
        //strncpy(inputCopy, input, inputLength);
        //if (inputLength > 0)
        //    inputCopy[inputLength - 1]= '\0';
        

        //firstWord = strtok_r (inputCopy, delimiter, &context);
        //secondWord = strtok_r (NULL, delimiter, &context);
        //thirdWord = strtok_r (NULL, delimiter, &context);
        //fourthWord = strtok_r (NULL, delimiter, &context);
        //a = strtok_r (NULL, delimiter, &context);
        //b = strtok_r (NULL, delimiter, &context);
        //c = strtok_r (NULL, delimiter, &context);
        //d = strtok_r (NULL, delimiter, &context);
        //e = strtok_r (NULL, delimiter, &context);
        //f = strtok_r (NULL, delimiter, &context);
        //g = strtok_r (NULL, delimiter, &context);
        //h = strtok_r (NULL, delimiter, &context);
        //i = strtok_r (NULL, delimiter, &context);
        //j = strtok_r (NULL, delimiter, &context);
        
        
        //remainder = context;
        
        //printf("%s%s\n", i, j);
        
        char *i = xxx;
        char *j = xxx;


        
        s1 = i;
        s2 = j;
        concat();
        
        //char *sx = search(both_words);
        
        //getchar();
    }
    
    close(pipe_arr[0]);
    close(pipe_arr[1]);
    
    return both_words;
}

void getFree(void **ptr)
{

    
    if(*ptr != NULL)
    {
        free(*ptr);
        *ptr = NULL;
    }
    
    return;
}

void ConnectionMain(){
    char *val = P(ipcc);
    printf("%s\n", val);
    char *valb = "0packets";

    
    charcount = 0;
    for(m=0; s1[m]; m++) {
        if(s1[m] != ' ') {
            charcount ++;
        }

    }
    printf("%s%i\n", "the count is", charcount);
    if(charcount > 80)
    {
        printf("%s\n", "connected");
        statuss = "connected";
        //free(concat);
        //return "noconneciton";
    }
    else if ( charcount < 75  && charcount > 5)
        
    {
        printf("%s\n", "noconnection");
        statuss = "noconnection";
        //free(concat);
        //return "connected";
    }
    
    else if ( charcount <= 4)
    {
        printf("%s\n", "retry");
        statuss = "retry";
    }
    
    s1 = NULL;
    s2 = NULL;
    results = NULL;
    both_words = NULL;
    ipcc = NULL;
        
}




//const char *TestConnection(const char *ip)
//{
//
//}
