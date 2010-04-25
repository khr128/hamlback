#ifndef HAML_INDENT_H
#define HAML_INDENT_H
enum indent_type { spaces, tabs, undefined } haml_indent_type = undefined;
int haml_indent_size = -1;
int haml_current_indent = -1;

int haml_set_space_indent(size_t indent)
{
  if(haml_indent_type != spaces) return 0; /* using wrong indent type */

  if(haml_indent_type == undefined)  
  {
    haml_current_indent = indent;
    haml_indent_size = indent;
    haml_indent_type = spaces;
    return 1;
  }



  return 1;
}
#endif /*HAML_INDENT_H*/

