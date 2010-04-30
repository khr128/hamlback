#include <string.h>
#include "haml_indent.h"

enum indent_type haml_indent_type = undefined;
int haml_indent_size = -1;
int haml_current_indent = -1;

int haml_set_space_indent(size_t indent)
{
  if(haml_indent_type == undefined)  
  {
    haml_current_indent = indent;
    haml_indent_size = indent;
    haml_indent_type = spaces;
    return 1; /* this is were indentation is initially defined */
  }

  if(haml_indent_type != spaces) return 0; /* using wrong indent type */

  if(indent % haml_indent_size != 0) return 0; /* inconsistent indent type */

  haml_current_indent = indent;

  return 1;
}
