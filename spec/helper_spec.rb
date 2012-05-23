require "rubygems"
require "bundler/setup"
$this_dir = File.dirname(__FILE__)
$this_dir_absolute = File.expand_path($this_dir)
require File.join($this_dir, "../helper")
$current_dir = Dir.pwd 

describe "Helper" do
  let (:test_dir)  {File.expand_path(File.join($this_dir_absolute, "..", 'test'))}

  it 'should resolve relative path' do
    relative("me").should == "#{$this_dir_absolute}/me"
  end
  it 'should execute in a given directory' do
    was_executed_in = exec_in("pwd",test_dir) 
    was_executed_in.strip.should == test_dir 
  end

  it 'should change back to current dir' do
    exec_in("pwd",test_dir) 
    Dir.pwd.should ==$current_dir  
  end
end
