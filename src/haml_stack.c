#include <stdlib.h>
#include <string.h>
#include "haml_stack.h"
int haml_sp = -1; /* empty stack */

struct HAML_STACK haml_null = { 0, 0 };
/*struct HAML_STACK haml_stack = { 0, 0 };*/

#define HAML_STACK_SIZE 1024
struct HAML_STACK stack[HAML_STACK_SIZE];

int haml_stack_pointer() {return haml_sp;}

struct HAML_STACK haml_peek()
{
  if(haml_sp < 0) return haml_null;
  return stack[haml_sp];
}

struct HAML_STACK haml_pop()
{
  if(haml_sp < 0) return haml_null;
  return stack[haml_sp--];
}

void haml_push(struct HAML_STACK stack_element)
{
  if(haml_sp == HAML_STACK_SIZE) return;
  haml_deep_copy(&stack[++haml_sp], &stack_element);
}

int haml_cmp(struct HAML_STACK el1, struct HAML_STACK el2)
{
  if(
      el1.tag_name == 0 && el2.tag_name != 0 ||
      el1.tag_name != 0 && el2.tag_name == 0 ||
      el1.indent == 0 && el2.indent != 0 ||
      el1.indent != 0 && el2.indent == 0
    ) return 0;
  else if (
      el1.tag_name == 0 && el2.tag_name == 0 &&
      el1.tag_name == 0 && el2.tag_name == 0
      ) return 1;
  else 
    return strcmp(el1.tag_name, el2.tag_name) == 0 &&
           strcmp(el1.indent, el2.indent) == 0;
}

void haml_clean(struct HAML_STACK *el)
{
  if(!el) return;
  if(el->tag_name) free(el->tag_name);
  if(el->indent) free(el->indent);

  el->tag_name = 0;
  el->indent = 0;
}

void haml_deep_copy(struct HAML_STACK *dst, struct HAML_STACK *src)
{
  dst->tag_name = src->tag_name ? strdup(src->tag_name) : 0;
  dst->indent = src->indent ? strdup(src->indent) : 0;
  dst->type = src->type;
}

void haml_execute_stack(stack_op f)
{
  /*call stack_op for each element, and empty and clean stack*/
  struct HAML_STACK el = haml_pop();
  while(!haml_cmp(el, haml_null))
  {
    if(f) f(&el);
    haml_clean(&el);
    el = haml_pop();
  }
}
