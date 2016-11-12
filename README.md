# opts.cr [![Build Status](https://travis-ci.org/maiha/opts.cr.svg?branch=master)](https://travis-ci.org/maiha/opts.cr)

a wrapper for OptionParser to provide default values and handy args

- worked on crystal-0.19.4

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  opts:
    github: maiha/opts.cr
```

## Opts module

### class methods

- `option` : declare a variable which is a proxy to OptionParser

### class consts

override `PROGRAM` `VERSION` `ARGS` `USAGE` as you like.
- see [src/opts.cr](src/opts.cr)

### instance methods

- `args` : command line args
- `parser` : a runtime instance of OptionParser
- `xxx` : a getter method defined by `option xxx`
- `version` : reserved for special option which delegates to `show_version`
- `help` : reserved for special option which delegates to `show_usage`

## Usage

```crystal
require "opts"

class Main
  include Opts

  VERSION = "0.1.0"
  PROGRAM = "foo"

  option host    : String, "-h host"  , "Server hostname", "127.0.0.1"
  option port    : Int32 , "-p port"  , "Server port number", 80
  option help    : Bool  , "--help"   , "Show this help", false
  option version : Bool  , "--version", "Print the version and exit", false

  def run
    p [host, port, args]
  end
end

Main.run
```

```shell
% ./foo
["127.0.0.1", 80, []]

% ./foo a
["127.0.0.1", 80, ["a"]]

% ./foo a b
["127.0.0.1", 80, ["a", "b"]]

% ./foo -h localhost a b
["localhost", 80, ["a", "b"]]

% ./foo --version
foo 0.1.0

% ./foo -x
foo version 0.1.0

Usage: foo

Options:
  -h host                          Server hostname (default: 127.0.0.1).
  -p port                          Server port number (default: 80).
  --help                           Show this help.
  --version                        Print the version and exit.

Invalid option: -x
```

## Further usages

Real products

- https://github.com/maiha/redis-cluster-benchmark.cr/blob/master/src/bin/main.cr
- https://github.com/maiha/dstat-redis.cr/blob/master/src/bin/main.cr
- https://github.com/maiha/rcm.cr/blob/master/src/bin/rcm.cr
- https://github.com/maiha/grafana-redis.cr/blob/master/src/bin/main.cr

## Contributing

1. Fork it ( https://github.com/maiha/opts.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
