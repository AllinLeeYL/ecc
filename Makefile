CC := g++
CFLAGS := -Wall -Wextra -std=c++11 # without debug
TARGET := ./bin/main

.PHONY:clean clean-complete type std all run different
all:compile
run:
	./test.out
arm-run:
	./test.out --target arm
l1:
	./test.out --level 1
l2:
	./test.out --level 2
l3:
	./test.out --level 3
l4:
	./test.out --level 4
arm-l1:
	./test.out --target arm --level 1
arm-l2:
	./test.out --target arm --level 2
arm-l3:
	./test.out --target arm --level 3
arm-l4:
	./test.out --target arm --level 4
noerrlog:
	./test.out --nolog
diffcheck:
	./test.out --diffcheck
type:
	./test.out --type
std:
	for file in $(basename $(shell find test/?/*.c)); \
	do \
		touch -a $$file.in; \
	done
different:
	for file in $(basename $(shell find test/?/*.c)); \
	do \
		cp -u $$file.c $$file.sy; \
	done
clean:
	rm -rf test/*/*.out test/*/*.output
	rm src/lexer.cpp src/parser.cpp src/parser.h src/parser.output src/pch.h.gch main.out

compile:
	bison -o src/parser.cpp --defines=src/parser.h -v src/parser.y
	flex --noyywrap -o src/lexer.cpp  src/lexer.l
	g++ -x c++-header -o src/pch.h.gch -c src/pch.h
	$(CC) $(CFLAGS) $(shell ls ./src/*.cpp) -o main.out

test1:
	gcc -g -m32 -o tests/mytest/test1.out ./test/mytest/test1.S
	gdb ./tests/mytest/test1.out