#ifndef HAML_HELPERS_H_
#define HAML_HELPERS_H_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *append(char *dst, char *src)
{
  char *text;
  if(dst)
  {
    text = (char *)calloc(strlen(dst)+strlen(src)+1, 1); 
    strcpy(text, dst); 
    strcat(text, src);
    free(dst);
  }
  else
  {
    text = (char *)calloc(strlen(src)+1, 1); 
    strcpy(text, src);
  }

  dst = text;
  return text;
}


#endif /*HAML_HELPERS_H_*/
