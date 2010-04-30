#ifndef HAML_STACK_H
#define HAML_STACK_H

#ifdef __cplusplus
 extern "C" {
#endif

#define TAG_NAME_STACK_SIZE 1024
#define HAML_STACK_SIZE 1024
extern int haml_sp; /* stack pointer */

struct HAML_STACK {
  char *tag_name;
  char *indent;
};

extern struct HAML_STACK haml_null;
extern struct HAML_STACK haml_stack;

extern struct HAML_STACK stack[HAML_STACK_SIZE];

extern struct HAML_STACK haml_peek();
extern struct HAML_STACK haml_pop();
extern void haml_push(struct HAML_STACK stack_element);
extern int haml_cmp(struct HAML_STACK el1, struct HAML_STACK el2);
extern void haml_clean(struct HAML_STACK *el);

#ifdef __cplusplus
}
#endif
#endif /*HAML_STACK_H*/
