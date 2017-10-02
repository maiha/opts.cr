require "../spec_helper"

private class App1
  include Opts

  option list : Array(String)       , "-s VALUE", "store into list" do list << v; end
  option hash : Hash(String, String), "-d VALUE", "store into hash" do
    key, val = v.split("=", 2)
    hash[key] = val
  end

  def run
  end
end

describe "example codes in README" do
  context "(with block)" do
    it "works" do
      app = App1.run("-s a -s b -d x=1 foo".split)
      app.list.should eq(["a", "b"])
      app.hash.should eq({"x" => "1"})
      app.args.should eq(["foo"])
    end
  end
end
