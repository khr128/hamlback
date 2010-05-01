#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "haml_stack.h"
#include "haml_indent.h"
#include "haml_string.h"

void close_previously_parsed_tags()
{
  /*close previously parsed tags if necessary*/
  haml_stack = haml_peek();
  while(!haml_cmp(haml_stack, haml_null) 
      && strlen(haml_stack.indent) >= haml_current_indent )
  {
    haml_stack = haml_pop();
    printf ("%s</%s>\n", haml_stack.indent, haml_stack.tag_name);  
    haml_clean(&haml_stack);
    haml_stack = haml_peek();
  }
}

void haml_free(int n, ...)
{
  va_list ptrs;
  va_start(ptrs, n);

  int i = 0;
  for (; i<n; ++i)
    free(va_arg(ptrs, void *));

  va_end(ptrs);
}

void push_tag_name(char *name, char *indent)
{
  close_previously_parsed_tags();
  haml_stack.tag_name = strdup(name);
  haml_stack.indent = strdup(indent);
  haml_push(haml_stack);
}

char *make_tag_name(char* indent, char *name)
{
  int indent_length = strlen(indent);
  if(indent_length == 0)
  {
    haml_current_indent = 0;
  }
  else
  {
    if(!haml_set_space_indent(indent_length))
      return 0;
  }

  push_tag_name(name, indent);

  char *tag_name = concatenate(3, indent, "<", name);
  haml_free(2, indent, name);

  return tag_name;
}
