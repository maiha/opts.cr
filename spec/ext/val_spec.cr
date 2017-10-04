require "../spec_helper"

private class App1
  val li  : Int32
  val lid : Int32 = 0
  var rid : Int32 = 0

  var rs  : String
  var rsd : String = "a"

  val lhd : Hash(String, String) = Hash(String, String).new
  var rhd : Hash(String, String) = Hash(String, String).new

  var rsnd : String? = nil
end

private class App2
  val int  = 0
  val str  = ""
  val bool = true
end

describe "Val" do
  context "(without default)" do
    it "String" do
      expect_raises(VarNotInitialized) do
        App1.new.li
      end
    end
  end

  context "(with default)" do
    it "Int32" do
      App1.new.lid.should eq(0)
    end

    it "Hash(String, String)" do
      App1.new.lhd.should eq(Hash(String, String).new)
    end
  end

  context "(Assign#Var)" do
    it "Int32" do
      App2.new.int.should eq(0)
    end

    it "String" do
      App2.new.str.should eq("")
    end

    it "Bool" do
      App2.new.bool.should eq(true)
    end
  end
end

describe "Var" do
  context "(without default)" do
    it "String" do
      expect_raises(VarNotInitialized) do
        App1.new.rs
      end
    end
  end

  context "(with default)" do
    it "Int32" do
      App1.new.rid.should eq(0)
    end

    it "Hash(String, String)" do
      App1.new.rhd.should eq(Hash(String, String).new)
    end

    it "String" do
      App1.new.rsd.should eq("a")
    end

    it "String?" do
      App1.new.rsnd.should eq(nil)
    end
  end
end
