require "./spec_helper"

private class Base
  include Opts

  option x : String, "-x VALUE", "option test", ""
  
  def run
  end
end

private class Sub < Base
end

describe "Inherit class" do
  it "works in base class" do
    app = Base.run(["-x", "abc"])
    app.x.should eq("abc")
  end

  it "works in subclass" do
    app = Sub.run(["-x", "abc"])
    app.x.should eq("abc")
  end
end
