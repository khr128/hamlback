#ifndef gtest_helpers_H_
#define gtest_helpers_H_
#include <gtest/gtest.h>

class HelpersTests : public ::testing::Test
{

public:
  virtual void SetUp();
  virtual void TearDown();

};
#endif //gtest_helpers_H_


