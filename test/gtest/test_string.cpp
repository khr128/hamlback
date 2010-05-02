#include "test_string.h"
#include <haml_string.h>

void StringTests::SetUp()
{}

void StringTests::TearDown()
{}

TEST_F(StringTests, AppendTest) 
{
  char *test = strdup("test ");
  char *appendstr =  strdup("string");
  char *expected = (char *) "test string";

  test = append(test, appendstr);
  
  ASSERT_EQ(0, strcmp(expected, test));
  free(test);
}

TEST_F(StringTests, ConcatenateTest) 
{
  char *test = strdup("test ");
  char *appendstr =  strdup("string");
  char *expected = (char *) "test string";

  test = concatenate(2, test, appendstr);
  
  ASSERT_EQ(0, strcmp(expected, test));
  free(test);
}

TEST_F(StringTests, TrimTest) 
{
  char *test = strdup(" test ");
  char *expected = (char *) "test";
  char *trimmed = strtrim(test, ' ');

  ASSERT_EQ(0, strcmp(expected, trimmed));

  free(test);
  free(trimmed);
}