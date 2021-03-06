#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

char *append(char *dst, const char *src)
{
  if(!src) return dst;
  if(!dst) return strdup(src);

  char *text;
  text = (char *)calloc(strlen(dst)+strlen(src)+1, 1); 
  strcpy(text, dst); 
  strcat(text, src);

  free(dst);
  return text;
}

char *concatenate(int n, ...)
{
  va_list strings;
  va_start(strings, n);

  char *concatenated_str = strdup(va_arg(strings, char *));
  int i;
  for (i=0; i<n-1; ++i)
    concatenated_str = append(concatenated_str, va_arg(strings, char *));

  va_end(strings);

  return concatenated_str;
}

char *strtrim(char *str, char c)
{
  size_t n = strlen(str);
  char *trimmed = strdup(str);

  if(n < 1) return trimmed; /* return a copy of empty string */
    
  if(*str == c) memcpy(trimmed, trimmed+1, n); /* trim from the left */

  if(n < 2) return trimmed; /* if initial string had just one charcter */

  if(*(str+n-1) == c) *(trimmed+strlen(trimmed)-1) = '\0'; /* trim from the right */

  return trimmed;
}

char *strtrim2(char *str, const char* tokens)
{
  char c;
  char *trimmed = strdup(str);
  char *tmp = 0;
  while( c=*tokens++ )
  {
    tmp = strtrim(trimmed, c);
    strcpy(trimmed, tmp);
    free(tmp);
  }
  return trimmed;
}
