#include "test_stack.h"

const char *test_tag_name = "test_tag_name";

void StackTests::SetUp()
{
  haml_execute_stack(0);
  haml_clean(&haml_stack);
  ASSERT_EQ(0, (unsigned long)haml_stack.tag_name);
  haml_stack.tag_name = strdup(test_tag_name);
  haml_stack.indent = strdup("");
  ASSERT_NE(0, (unsigned long)haml_stack.tag_name);
}

void StackTests::TearDown()
{
  haml_execute_stack(0);
  haml_clean(&haml_stack);
}

TEST_F(StackTests, PopEmptyStackTest) 
{
  ASSERT_EQ(-1, haml_stack_pointer());
  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
}

TEST_F(StackTests, PushPopTest) 
{
  ASSERT_EQ(-1, haml_stack_pointer());
  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());

  haml_push(haml_stack);
  ASSERT_EQ(0, haml_stack_pointer());

  struct HAML_STACK haml_popped = haml_pop();
  ASSERT_EQ(1, haml_cmp(haml_stack, haml_popped));
  ASSERT_EQ(-1, haml_stack_pointer());
  haml_clean(&haml_popped);

  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());

  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
}

TEST_F(StackTests, PushPushPopPopTest) 
{
  ASSERT_EQ(-1, haml_stack_pointer());
  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());

  haml_push(haml_stack);
  ASSERT_EQ(0, haml_stack_pointer());

  struct HAML_STACK haml_stack_2 = { 0, 0 };
  const char *new_tag_name = "new_tag_name";
  const char *indent = "   ";
  haml_stack_2.tag_name = strdup(new_tag_name);
  haml_stack_2.indent = strdup(indent);

  haml_push(haml_stack_2);
  ASSERT_EQ(1, haml_stack_pointer());

  struct HAML_STACK haml_popped = haml_pop();
  ASSERT_EQ(1, haml_cmp(haml_stack_2, haml_popped));
  ASSERT_EQ(0, haml_stack_pointer());
  haml_clean(&haml_stack_2);
  haml_clean(&haml_popped);

  haml_popped = haml_pop();
  ASSERT_EQ(1, haml_cmp(haml_stack, haml_popped));
  ASSERT_EQ(-1, haml_stack_pointer());
  haml_clean(&haml_stack);
  haml_clean(&haml_popped);

  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
}


TEST_F(StackTests, PushPeekTest) 
{
  ASSERT_EQ(-1, haml_stack_pointer());
  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());

  haml_push(haml_stack);
  ASSERT_EQ(0, haml_stack_pointer());

  ASSERT_EQ(1, haml_cmp(haml_stack, haml_peek()));
  ASSERT_EQ(0, haml_stack_pointer());

  ASSERT_EQ(1, haml_cmp(haml_stack, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
  haml_clean(&haml_stack);

  ASSERT_EQ(1, haml_cmp(haml_null, haml_pop()));
  ASSERT_EQ(-1, haml_stack_pointer());
}
