#ifndef gtest_helpers_H_
#define gtest_helpers_H_
#include <gtest/gtest.h>
#include <haml_stack.h>

class HelpersTests : public ::testing::Test
{
public:
  HelpersTests()
  {
    haml_stack.tag_name = 0;
    haml_stack.indent = 0;
  }
public:
  virtual void SetUp();
  virtual void TearDown();

protected:
  struct HAML_STACK haml_stack;
};
#endif //gtest_helpers_H_


