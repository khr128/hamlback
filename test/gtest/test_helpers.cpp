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

  push_tag_name(tag_name, indent);
}

