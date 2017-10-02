require "../spec_helper"

private class App2
  include Opts

  option token : String?, "-a TOKEN", "Your access token", nil

  def run
  end
end

describe "example codes in README" do
  context "(nilable)" do
    it "works" do
      App2.run.token.should eq(nil)
      App2.run(["-a", "xxx"]).token.should eq("xxx")
    end
  end
end
