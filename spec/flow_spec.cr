require "./spec_helper"

private class App1
  include Opts

  property breadcrumbs   : Array(String) = Array(String).new
  property accepted_args : Array(String) = Array(String).new

  def initialize
    breadcrumbs << "new"
  end

  def setup(args : Array(String))
    breadcrumbs << "setup(args)"
    super(args)
    @accepted_args = args
  end

  def setup
    breadcrumbs << "setup"
  end

  def run
    breadcrumbs << "run"
    return self # to access breadcrumbs from outside
  end
end

describe "Instance Method Flow" do
  it "should be [new, setup(args), setup, run]" do
    app = App1.run(["a", "b"]).not_nil!
    app.breadcrumbs.should eq(["new", "setup(args)", "setup", "run"])
  end

  it "should accept class level args" do
    app = App1.run(["a", "b"]).not_nil!
    app.accepted_args.should eq(["a", "b"])
  end
end
