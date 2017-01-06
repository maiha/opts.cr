SHELL = /bin/bash

.PHONY : all test foo spec clean

all: test

test: check_version_mismatch spec

foo: examples/foo.cr
	crystal build $^

spec: foo
	crystal spec -v

clean:
	rm -f foo

.PHONY : check_version_mismatch
check_version_mismatch: shard.yml README.md
	diff -w -c <(grep version: README.md) <(grep ^version: shard.yml)
