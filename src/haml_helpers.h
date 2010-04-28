#ifndef HAML_HELPERS_H_
#define HAML_HELPERS_H_

#include <stdio.h>
#include <stdlib.h>
#include "haml_string.h"
#include "haml_stack.h"
#include "haml_indent.h"

void close_previously_parsed_tags()
{
  /*close previously parsed tags if necessary*/
  haml_stack = haml_peek();
  while(!haml_cmp(haml_stack, haml_null) 
      && strlen(haml_stack.indent) >= haml_current_indent )
  {
    haml_stack = haml_pop();
    printf ("%s</%s>\n", haml_stack.indent, haml_stack.tag_name);  
    haml_stack = haml_peek();
  }
}
#endif /*HAML_HELPERS_H_*/
