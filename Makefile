run: main.rkt mylib.so
	@racket main.rkt
	
.PHONY: run

mylib.so: lib.cc
	@g++ -std=c++17 -Wall -Wextra -fPIC -shared -o $@ lib.cc

