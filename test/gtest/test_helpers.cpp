#include "test_helpers.h"
#include <haml_helpers.h>

void HelpersTests::SetUp()
{
  haml_execute_stack(0);
  haml_clean(&haml_stack);
}

void HelpersTests::TearDown()
{
  haml_execute_stack(0);
  haml_clean(&haml_stack);
}

TEST_F(HelpersTests, PushTagNameTest) 
{
  char *indent = (char*)"       ";
  char *tag_name = (char*)"tag_name";

  ASSERT_EQ(-1, haml_stack_pointer());
  push_tag_name(tag_name, indent, html);

  ASSERT_EQ(0, haml_stack_pointer());
  struct HAML_STACK expected = { tag_name, indent };
  ASSERT_EQ(1, haml_cmp(expected, haml_peek()));
}

TEST_F(HelpersTests, MakeTagNameTest) 
{
  char *indent = strdup("       ");
  char *tag_name = strdup("tag_name");

  ASSERT_EQ(-1, haml_stack_pointer());
  struct HAML_STACK expected = { strdup(tag_name), strdup(indent) };

  char* generated_name = make_tag_name(tag_name, indent);

  ASSERT_EQ(0, haml_stack_pointer());
  struct HAML_STACK peeked = haml_peek();
  ASSERT_EQ(1, haml_cmp(expected, peeked)) << peeked.tag_name << " |" << peeked.indent << '|';

  haml_clean(&expected);
  free(generated_name);
}
