$this_dir = File.dirname(__FILE__)
require 'rspec'
require File.join($this_dir, '..', 'helper')
require_relative '../app_metadata'


describe AppMetadata do
  before(:all) do
    if File.directory?(File.join($this_dir, '../test/data'))
      FileUtils.rm_r File.join($this_dir, '../test/data')
    end
    FileUtils.cp_r File.join($this_dir, '../test/app_service_data'), File.join($this_dir, '../test/data')
  end
  
  it 'should load apps_from_yaml' do
    am = AppMetadata.new File.join($this_dir, '../test/data/meta/apps.yaml')
    am.app_repos.length.should == 5
  end
end
