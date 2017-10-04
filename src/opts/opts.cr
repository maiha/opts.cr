module Opts
  PROGRAM = "#{$0}".split("/").last
  VERSION = Shard.git_description.split(/\s+/, 2).last
  ARGS    = ""
  USAGE   = <<-EOF
    {{version}}

    Usage: {{program}} {{args}}

    Options:
    {{options}}
    EOF

  property argv : Array(String) = ARGV
  @args : Array(String)?

  # [app flow] step1 : setup args
  def setup(argv : Array(String))
    self.argv = argv
    args                        # kick parse!
    setup
  end

  # [app flow] step2 : setup apps
  def setup
    self.exit(show_usage) if responds_to?(:help) && self.help
    self.exit(show_version) if responds_to?(:version) && self.version
  end

  # [app flow] step3 : main routine
  abstract def run

  def run(argv : Array(String))
    setup(argv)
    run
  rescue err
    on_error(err)
  end

  def args : Array(String)
    if @args.nil?
      begin
        option_parser.parse(@argv)
        @args = @argv
      rescue err : ArgumentError | Opts::Error | OptionParser::Exception
        die err.to_s
      end
    end
    @args.not_nil!
  end

  @option_parser : OptionParser?
  
  protected def option_parser
    @option_parser ||= new_option_parser
  end

  def new_option_parser : OptionParser
    Parser.new.tap{|p|
      {% for methods in ([@type] + @type.ancestors).map(&.methods.map(&.name.stringify)) %}
        {% for name in methods %}
          {% if name =~ /\Aregister_option_/ %}
            {{name.id}}(p)
          {% end %}
        {% end %}
      {% end %}
    }
  end
  
  def on_error(err : Exception)
    STDERR.puts err.to_s.colorize(:red)
    err.inspect_with_backtrace(STDERR)
    exit 1
  end
    
  protected def die(reason : String)
    STDERR.puts show_usage
    STDERR.puts ""
    STDERR.puts reason.colorize(:red)
    exit -1
  end

  protected def exit(message : String)
    STDOUT.puts message
    exit 0
  end

  macro included
    def self.run(argv = ARGV)
      new.tap(&.run(argv))
    end

    def show_usage
      USAGE.gsub(/\{{version}}/, show_version).gsub(/\{{program}}/, PROGRAM).gsub(/\{{args}}/, ARGS).gsub(/\{{options}}/, new_option_parser.to_s)
    end

    def show_version
      "#{PROGRAM} #{VERSION}"
    end
  end
end

# Base must be defined after `Opts` module due to included macro.
class Opts::Base
  include Opts

  def run
  end
end
