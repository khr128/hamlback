#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "haml_stack.h"
#include "haml_indent.h"
#include "haml_string.h"

void check_previous_tag()
{
  struct HAML_STACK el = { 0, 0 };
  el = haml_peek();
  switch(el.type)
  {
    case ruby_code:
      if(haml_get_current_indent() - strlen(el.indent) != haml_get_indent_size())
      {
        el = haml_pop();
        haml_clean(&el);
      }
      break;
  }
}

void close_previously_parsed_tags()
{
  /*close previously parsed tags if necessary*/
  struct HAML_STACK el = { 0, 0 };
  el = haml_peek();
  while(!haml_cmp(el, haml_null) 
      && strlen(el.indent) >= haml_get_current_indent() )
  {
    el = haml_pop();
    switch(el.type)
    {
      case html:
        printf ("%s</%s>\n", el.indent, el.tag_name);
        break;
      case ruby_code:
        printf ("%s<%% end %%>\n", el.indent);
        break;
    }
    haml_clean(&el);
    el = haml_peek();
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

void push_tag_name(char *name, char *indent, enum tag_type type)
{
  close_previously_parsed_tags();
  struct HAML_STACK el = { name, indent, type };
  haml_push(el);
}

char *make_tag_name(char *name, char* indent)
{
  int indent_length = strlen(indent);
  if(indent_length == 0)
  {
    haml_set_current_indent(0);
  }
  else
  {
    if(!haml_set_space_indent(indent_length))
      return 0;
  }

  push_tag_name(name, indent, html);

  char *tag_name = concatenate(3, indent, "<", name);
  haml_free(2, indent, name);

  return tag_name;
}

char* print_indented_tag(char *match, char* tokens, const char *code_fmt, const char *trim)
{
  char *indent = strtok(match, tokens);
  if(indent != match)
  {
    haml_set_current_indent(0);
    close_previously_parsed_tags();
    char *code = strtrim2(indent, trim);
    printf (code_fmt, code);  
    haml_free(2, code, match);

    haml_set_current_indent(0);
    return strdup("");
  }
  else
  {
    char *code = strtrim2(match+strlen(indent)+1, trim);
    if(haml_set_space_indent(strlen(indent)))
    {
      close_previously_parsed_tags();
      char* indented_code_fmt = append(strdup("%s"), code_fmt);
      printf (indented_code_fmt, indent, code);  
      indent = strdup(indent);
      haml_free(3, match, indented_code_fmt, code);
      return indent;
    }
    free(code);
  }
}
