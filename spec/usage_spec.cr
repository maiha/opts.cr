require "./spec_helper"

private class Main < Opts::Base
end

private class MainWithOptionN < Opts::Base
  option n : Int32, "-n num"  , "give a number", 1
end

private class MainWithProgram
  include Opts
  PROGRAM = "foo"
  def run
  end
end

private class MainWithVersion
  include Opts
  VERSION = "123"
  def run
  end
end

private class MainWithArgs
  include Opts
  ARGS = "file1 file2"
  def run
  end
end

private class MainWithUsage
  include Opts
  USAGE = "custom usage"
  def run
  end
end

private class MainWithRun
  include Opts
  def run
    self
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
        Main.new.show_usage.split.first.should eq("crystal-run-spec.tmp")
      end

      it "should resolve parameters in default" do
        usage = Main.new.show_usage
        usage.should_not contain("{{version}}")
        usage.should_not contain("{{program}}")
        usage.should_not contain("{{args}}")
        usage.should_not contain("{{options}}")
      end
      
      it "should respect PROGRAM const" do
        usage = MainWithProgram.new.show_usage
        usage.starts_with?("foo ").should be_true
        usage.should contain("Usage: foo ")
      end
    end

    describe "#show_version" do
      it "should return 'name' in default" do
        Main.new.show_version.should match(/^crystal-run-spec.tmp /)
      end

      it "should respect VERSION const" do
        MainWithVersion.new.show_version.should match(/ 123$/)
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

    it "should set #argv" do
      main = MainWithRun.run(["a", "b"])
      main.argv.should eq(["a", "b"])
    end
  end
end
