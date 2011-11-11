require 'rspec'
$this_dir = File.dirname(__FILE__)
require File.join($this_dir, '..', 'app_service') 
require 'fileutils'

def data_dir
    relative('../test/data')
end

describe AppService do
  before(:all) do
    if File.directory?(data_dir)
      FileUtils.rm_r data_dir
    end
    FileUtils.cp_r relative('../test/app_service_data'), data_dir
  end
  
  context 'With own data' do
    let (:app_service) { AppService.new(
     [ContentDirectory.new({:slug=>'first_app', :name=>'first app'}), ContentDirectory.new({:slug=>'second_app', :name=>'second app'})],
     [ContentDirectory.new({:slug=>'first_dev', :name=>'first dev'}), ContentDirectory.new({:slug=>'second_dev', :name=>'second dev'})]
    )}
    it 'apps should be non empty' do
      app_service.apps.should_not be_nil
    end

    it 'should find items by slug' do
      second = app_service.get 'second_app'
      second.name.should == 'second app'
    end
    it 'should find devs by slug' do
      second = app_service.get_dev 'second_dev'
      second.name.should == 'second dev'
    end
    it 'should return nil when cannot find dev' do
      second = app_service.get_dev 'blah'
      second.nil?.should be_true
    end
  end
  context 'With loading file data' do
    let (:app_service) { AppService.load_from_file data_dir}
    
    it 'should contain two apps from the file' do
      app_service.get("app1").slug.should == "app1"
    end

    it 'should load names from info.yaml' do
      app_service.get("app1").name.should == 'Rates Tracker'
    end
    it 'should load description from description.md' do
      app_service.get("app1").description.should == "Allows you to track rates.\n"
    end
    it 'should load body from body.md' do
      app_service.get("app1").body.should == "Allows you to track rates.\nFull description\n"
    end
    it 'should not show app if the app dir is not around' do
      app_service.apps.length.should == 3
    end
    it 'should load the app with no description and body' do
      app_service.get("app_no_files").name.should == 'No app files'
      app_service.get("app_no_files").description.should be_nil
      app_service.get("app_no_files").body.should be_nil
    end
  end
end
