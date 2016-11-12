require "./spec_helper"

private class Main
  include Opts
end

private class MainWithOptionN
  include Opts
  option n : Int32, "-n num"  , "give a number", 1
end

private class MainWithProgram
  include Opts
  PROGRAM = "foo"
end

private class MainWithVersion
  include Opts
  VERSION = "123"
end

private class MainWithArgs
  include Opts
  ARGS = "file1 file2"
end

private class MainWithUsage
  include Opts
  USAGE = "custom usage"
end

private class MainWithRun
  include Opts
  def run
  end
end

describe "usage features" do
  describe "#usage" do
    describe "(options)" do
      it "should respect option descriptions" do
        MainWithOptionN.new.show_usage.should match(/give a number \(default: 1\)/)
      end
    end

    describe "(program name)" do
      it "should return $0 in default" do
        Main.new.show_usage.starts_with?("crystal-run-spec.tmp").should be_true
      end

      it "should respect PROGRAM const" do
        MainWithProgram.new.show_usage.starts_with?("foo ").should be_true
      end
    end

    describe "(version)" do
      it "should return 'unknown' in default" do
        Main.new.show_usage.should match(/version unknown/)
      end

      it "should respect VERSION const" do
        MainWithVersion.new.show_usage.should match(/version 123/)
      end
    end

    describe "(args)" do
      it "should respect ARGS const" do
        MainWithArgs.new.show_usage.should match(/ file1 file2\n/)
      end
    end

    describe "(usage)" do
      it "should respect USAGE const" do
        MainWithUsage.new.show_usage.should eq("custom usage")
      end
    end
  end

  describe ".run" do
    it "should work without help option" do
      # nothing raised
      MainWithRun.run
    end
  end
end
