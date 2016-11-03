require "./spec_helper"

private macro it_run(command, expected)
  it {{command}} do
    `{{command.id}} 2>&1`.chomp.should eq({{expected}})
  end
end

describe "example/foo.cr" do
  it_run "./foo",
         %(["127.0.0.1", 80, []])

  it_run "./foo a",
         %(["127.0.0.1", 80, ["a"]])

  it_run "./foo a b",
         %(["127.0.0.1", 80, ["a", "b"]])
  
  it_run "./foo -h localhost a b",
         %(["localhost", 80, ["a", "b"]])
end
