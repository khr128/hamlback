#ifndef HAML_STACK_H
#define HAML_STACK_H

#define TAG_NAME_STACK_SIZE 1024
int tag_name_sp = -1; /* empty stack */
char *tag_name_stack[TAG_NAME_STACK_SIZE];

char *pop_name()
{
  if(tag_name_sp < 0) return 0;
  return tag_name_stack[tag_name_sp--];
}

void push_name(char *name)
{
  if(tag_name_sp == TAG_NAME_STACK_SIZE) return;
  tag_name_stack[++tag_name_sp] = name;
}

#endif /*HAML_STACK_H*/
