#include "test_indent.h"
#include <haml_indent.h>

void IndentTests::SetUp()
{
  haml_indent_size = -1;
  haml_current_indent = -1;
  haml_indent_type = undefined;
}

void IndentTests::TearDown()
{}

TEST_F(IndentTests, InstantiationTest) 
{
  ASSERT_EQ(-1, haml_indent_size);
  ASSERT_EQ(-1, haml_current_indent);
  ASSERT_EQ(undefined, haml_indent_type);
}

TEST_F(IndentTests, SetFirstIndentTest) 
{
  ASSERT_EQ(-1, haml_indent_size);
  ASSERT_EQ(-1, haml_current_indent);
  ASSERT_EQ(undefined, haml_indent_type);

  int numspaces = 7;
  int ret = haml_set_space_indent(numspaces);

  ASSERT_NE(0, ret);
  ASSERT_EQ(numspaces, haml_indent_size);
  ASSERT_EQ(numspaces, haml_current_indent);
  ASSERT_EQ(spaces, haml_indent_type);
}


TEST_F(IndentTests, SetSecondIndentTest) 
{
  ASSERT_EQ(-1, haml_indent_size);
  ASSERT_EQ(-1, haml_current_indent);
  ASSERT_EQ(undefined, haml_indent_type);

  int numspaces = 7;
  int ret = haml_set_space_indent(numspaces);

  ASSERT_NE(0, ret);
  ASSERT_EQ(numspaces, haml_indent_size);
  ASSERT_EQ(numspaces, haml_current_indent);
  ASSERT_EQ(spaces, haml_indent_type);

  ret = haml_set_space_indent(2*numspaces);

  ASSERT_NE(0, ret);
  ASSERT_EQ(numspaces, haml_indent_size);
  ASSERT_EQ(2*numspaces, haml_current_indent);
  ASSERT_EQ(spaces, haml_indent_type);
}
