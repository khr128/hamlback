#include <stdlib.h>
#include <stdio.h>
#include "haml_continuation.h"

char* haml_continue_line = 0;

char* haml_get_continue_line() {return haml_continue_line;}
void haml_set_continue_line(char* closing_statement) 
{
  if(closing_statement && !haml_continue_line)
    haml_continue_line = closing_statement;
  else if(!closing_statement && haml_continue_line)
  {
    free(haml_continue_line);
    haml_continue_line = 0;
  }
  else
    fprintf(stderr, "error in haml_set_continue: inconsistent line continuation.");
}
