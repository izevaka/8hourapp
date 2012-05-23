require "rubygems"
require "bundler/setup"
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
  
  let(:app_meta) { AppMetadata.new File.join($this_dir, '../test/data/meta/apps.yaml') }
  
  it 'should load apps_from_yaml' do
    app_meta.app_repos.length.should == 5
  end
  it 'should update apps when meta repo is updated' do
    repo_dir =  File.join($this_dir, '../test/data/meta_origin')
    apps_yaml = File.open(File.join(repo_dir, "apps.yaml"), "a")
    apps_yaml.write "  app7:\n"
    apps_yaml.write "    repo: blah\n"
    apps_yaml.write "    email: blahf\n"
    apps_yaml.close

    exec_in('git add .', repo_dir) 
    exec_in('git commit -m"test message"', repo_dir) 

    app_meta.check_updates!
    app_meta.app_repos.length.should == 6
  end
end
