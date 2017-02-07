require "./spec_helper"

private class Main
  include Opts

  def run
    raise "foo"
  end

  def on_error(err)
    -1
  end
end

describe "error handlings" do
  describe ".run" do
    it "should respect #on_error instance method" do
      Main.run.should eq(-1)
    end
  end
end
