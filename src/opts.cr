require "option_parser"
require "colorize"
require "shard"
require "./lib/*"

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

  class OptionError < Exception
  end

  property argv : Array(String) = ARGV

  abstract def run
  def run(argv : Array(String))
    self.argv = argv
    args                        # kick parse!
    self.exit(show_usage) if responds_to?(:help) && self.help
    self.exit(show_version) if responds_to?(:version) && self.version
    run
  rescue err
    on_error(err)
  end
    
  @args : Array(String)?

  macro expect_error(klass)
    begin
      {{yield}}
    rescue err : {{klass.id}}
      die err.to_s
    end
  end
            
  def args : Array(String)
    if @args.nil?
      begin
        option_parser.parse(@argv)
        @args = @argv
      rescue err : ArgumentError | Opts::OptionError | OptionParser::Exception
        die err.to_s
      end
    end
    @args.not_nil!
  end

  macro option(name, long, desc, default)
    var {{name}}, {{default}}

    {% if name.type.stringify == "Bool" %}
      def {{name.var.id}}? ; {{name.var.id}} ; end
    {% end %}
    
    def register_option_{{name.var.id}}(parser)
      {% if long.stringify =~ /[\s=]/ %}
        {% if name.type.stringify == "Int64" %}
          parser.on({{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i64}
        {% elsif name.type.stringify.starts_with?("Int32") %}
          parser.on({{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i32}
        {% elsif name.type.stringify == "Int16" %}
          parser.on({{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i16}
        {% elsif name.type.stringify =~ /::Nil$/ %}
          parser.on({{long}}, "{{desc.id}}.") {|x| self.{{name.var}} = x}
        {% else %}
          parser.on({{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x}
        {% end %}
      {% else %}
        parser.on({{long}}, "{{desc.id}}.") {self.{{name.var}} = true}
      {% end %}
    end
  end

  macro option(name, short, long, desc, default)
    var {{name}}, {{default}}

    {% if name.type.stringify == "Bool" %}
      def {{name}}? ; {{name}} ; end
    {% end %}
    
    def register_option_{{name.var.id}}(parser)
      {% if long.stringify =~ /[\s=]/ %}
        {% if name.type.stringify == "Int64" %}
          parser.on({{short}}, {{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i64}
        {% elsif name.type.stringify == "Int32" %}
          parser.on({{short}}, {{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i32}
        {% elsif name.type.stringify == "Int16" %}
          parser.on({{short}}, {{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x.to_i16}
        {% elsif name.type.stringify =~ /::Nil$/ %}
          parser.on({{short}}, {{long}}, "{{desc.id}}.") {|x| self.{{name.var}} = x}
        {% else %}
          parser.on({{short}}, {{long}}, "{{desc.id}} (default: {{default.id}}).") {|x| self.{{name.var}} = x}
        {% end %}
      {% else %}
         parser.on({{short}}, {{long}}, "{{desc.id}}.") {self.{{name.var}} = true}
      {% end %}
    end
  end

  macro options(*names)
    {% for name in names %}
      option_{{name.id.stringify.id}}
    {% end %}
  end

  @option_parser : OptionParser?
  
  protected def option_parser
    @option_parser ||= new_option_parser
  end

  macro def new_option_parser : OptionParser
    OptionParser.new.tap{|p|
      {% for name in @type.methods.map(&.name.stringify) %}
        {% if name =~ /\Aregister_option_/ %}
          {{name.id}}(p)
        {% end %}
      {% end %}
    }
  end

  # should be overridden by subclass
  protected def verbose?
    false
  end
  
  protected def on_error(err : Exception)
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
      new.run(argv)
    end

    def show_usage
      USAGE.gsub(/\{{version}}/, show_version).gsub(/\{{program}}/, PROGRAM).gsub(/\{{args}}/, ARGS).gsub(/\{{options}}/, new_option_parser.to_s)
    end

    def show_version
      "#{PROGRAM} #{VERSION}"
    end
  end
end
