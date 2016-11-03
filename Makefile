SHELL = /bin/bash

.PHONY : all test foo spec clean

all: test

test: spec

foo: examples/foo.cr
	crystal build $^

spec: foo
	crystal spec -v

clean:
	rm -f foo
