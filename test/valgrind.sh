#! /bin/sh
pwd
valgrind --leak-check=full $1 < $2 2>valgrind.test.out
cat valgrind.test.out
