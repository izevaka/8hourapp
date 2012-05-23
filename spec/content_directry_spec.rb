require "rubygems"
require "bundler/setup"
require 'rspec'
$this_dir = File.dirname(__FILE__)
require File.join($this_dir, '..', 'app_service') 
require 'fileutils'

def data_dir
    relative('../test/data')
end

describe ContentDirectory do
  let( :data_dir) {relative('../test/data')}
  before(:all) do
    if File.directory?(data_dir)
      FileUtils.rm_r data_dir
    end
    FileUtils.cp_r relative('../test/app_service_data'), data_dir
  end
  
  context 'When creating' do
    it 'should fill name, description and body from directory' do
      app = App.from_directory File.join(data_dir, 'repos/app1'), 'app1'

      app.name.should == 'Rates Tracker'
      app.slug.should == 'app1'
      app.description.should == "Allows you to track rates.\n"
      app.body.should == "Allows you to track rates.\nFull description\n"
    end
    it 'should load yaml regardless of what the root node is' do
      dev = App.from_directory File.join(data_dir, 'devs/dev1'), 'dev1'
      dev.name.should == 'Igor'
    end
  end

end


