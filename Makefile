run: main.rkt mylib.so
	@racket main.rkt

pidfd-experiment: mylib.so wait-subprocess-pidfd.rkt
	@racket wait-subprocess-pidfd.rkt
	
.PHONY: run

mylib.so: lib.cc pidfd.cc
	@g++ -std=c++17 -Wall -Wextra -fPIC -shared -o $@ lib.cc pidfd.cc

