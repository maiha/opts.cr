require "./spec_helper"

private class App1
  val li : Int32 = 0
  var ri : Int32 = 0

  var rs : String = "a"

  val lh : Hash(String, String) = Hash(String, String).new
  var rh : Hash(String, String) = Hash(String, String).new

  var rsn : String? = nil
end

describe "Val" do
  it "Int32" do
    App1.new.li.should eq(0)
  end

  it "Hash(String, String)" do
    App1.new.lh.should eq(Hash(String, String).new)
  end
end

describe "Var" do
  it "Int32" do
    App1.new.ri.should eq(0)
  end

  it "Hash(String, String)" do
    App1.new.rh.should eq(Hash(String, String).new)
  end

  it "String" do
    App1.new.rs.should eq("a")
  end

  it "String?" do
    App1.new.rsn.should eq(nil)
  end
end
