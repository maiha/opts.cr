require "./spec_helper"

private class Main
  include Opts

  property error_code : Int32 = 0
  
  def run
    raise "foo"
  end

  def on_error(err)
    @error_code = -1
  end
end

describe "error handlings" do
  describe ".run" do
    it "should failback to #on_error instance method" do
      Main.run.error_code.should eq(-1)
    end
  end
end
