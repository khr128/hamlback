#ifndef HAML_STACK_H
#define HAML_STACK_H

#ifdef __cplusplus
 extern "C" {
#endif

enum tag_type { html, ruby_code };

struct HAML_STACK {
  char *tag_name;
  char *indent;
  enum tag_type type;
};

extern struct HAML_STACK haml_null;
/*extern struct HAML_STACK haml_stack;*/

extern int haml_stack_pointer();
extern struct HAML_STACK haml_peek();
extern struct HAML_STACK haml_pop();
extern void haml_push(struct HAML_STACK stack_element);
extern int haml_cmp(struct HAML_STACK el1, struct HAML_STACK el2);
extern void haml_clean(struct HAML_STACK *el);
extern void haml_deep_copy(struct HAML_STACK *dst, struct HAML_STACK *src);
typedef void (*stack_op)(struct HAML_STACK *el);
extern void haml_execute_stack(stack_op f);

#ifdef __cplusplus
}
#endif
#endif /*HAML_STACK_H*/
