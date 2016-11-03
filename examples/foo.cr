require "../src/opts"

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
