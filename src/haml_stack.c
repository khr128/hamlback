#include <stdlib.h>
#include "haml_stack.h"
int haml_sp = -1; /* empty stack */

struct HAML_STACK haml_null = { 0, 0 };
struct HAML_STACK haml_stack = { 0, 0 };
struct HAML_STACK stack[HAML_STACK_SIZE];

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
  stack[++haml_sp] = stack_element;
}

int haml_cmp(struct HAML_STACK el1, struct HAML_STACK el2)
{
  return el1.tag_name == el2.tag_name &&
    el1.indent == el2.indent;
}

void haml_clean(struct HAML_STACK *el)
{
  free(el->tag_name);
  free(el->indent);

  el->tag_name = 0;
  el->indent = 0;
}
