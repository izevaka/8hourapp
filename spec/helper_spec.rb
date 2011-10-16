$this_dir = File.dirname(__FILE__)
require File.join($this_dir, "../helper")

describe "Helper" do
  it 'should resolve relative path' do
    relative("me").should == "#{File.expand_path($this_dir)}/me"
  end
end
