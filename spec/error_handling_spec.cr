require "./spec_helper"

private class App1
  include Opts

  property error_code : Int32 = 0
  
  def run
    raise "foo"
  end

  def on_error(err)
    @error_code = -1
  end
end

private class App2
  include Opts

  def run
    raise "foo"
  end

  def on_error(err)
    raise err
  end
end

describe "error handlings" do
  describe ".run" do
    it "should failback to #on_error instance method" do
      App1.run.error_code.should eq(-1)
    end
  end

  describe "#on_error" do
    it "should preserve last callstack" do
      
    end
  end
end
