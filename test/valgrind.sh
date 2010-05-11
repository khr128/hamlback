#! /bin/sh
pwd
if [ $# -gt 1 ]
then
valgrind --leak-check=full $1 < $2 2>valgrind.test.out
else
valgrind --leak-check=full $1 2>valgrind.test.out
fi

cat valgrind.test.out
