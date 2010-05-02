#include <string.h>
#include "haml_indent.h"

enum indent_type haml_indent_type = undefined;
int haml_indent_size = -1;
int haml_current_indent = -1;

int haml_get_current_indent() {return haml_current_indent;}
void haml_set_current_indent(int indent_size) {haml_current_indent = indent_size;}

int haml_get_indent_size() {return haml_indent_size;}
void haml_set_indent_size(int indent_size) {haml_indent_size = indent_size;}

void haml_set_indent_type(enum indent_type type) {haml_indent_type = type;}
enum indent_type haml_get_indent_type() {return haml_indent_type;}

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
