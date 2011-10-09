require 'rspec'
$this_dir = File.dirname(__FILE__)
require File.join($this_dir, '..', 'app_service') 
require 'fileutils'

describe AppService do
  if File.directory?(File.join($this_dir, '../test/data'))
    FileUtils.rm_r File.join($this_dir, '../test/data')
  end
  FileUtils.cp_r File.join($this_dir, '../test/app_service_data'), File.join($this_dir, '../test/data')
  
  context 'With own data' do
    app_service = AppService.new [App.new('first', 'first'), App.new('second', 'second')] 
    it 'apps should be non empty' do
      app_service.apps.should_not be_nil
    end

    it 'should find items by slug' do
      second = app_service.get 'second'
      second.description.should == 'second'
    end
  end
  context 'With loading file data' do
    app_service = AppService.load_from_file 'test/data'
    
    it 'should contain two apps from the file' do
      app_service.get("app1").slug.should == "app1"
    end

    it 'should load names from app.yaml' do
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
