require 'rspec'
$this_dir = File.dirname(__FILE__)
require File.join($this_dir, '..', 'app_service') 
require 'fileutils'

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
      app = ContentDirectory.from_directory File.join(data_dir, 'repos/app1'), 'app1'

      app.name.should == 'Rates Tracker'
      app.slug.should == 'app1'
      app.description.should == "Allows you to track rates.\n"
      app.body.should == "Allows you to track rates.\nFull description\n"
    end
    it 'should load yaml regardless of what the root node is' do
      dev = ContentDirectory.from_directory File.join(data_dir, 'devs/dev1'), 'dev1'
      dev.name.should == 'Igor'
    end
  end

end

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
     [ContentDirectory.new('first_app', 'first app'), ContentDirectory.new('second_app', 'second app')],
     [ContentDirectory.new('first_dev', 'first dev'), ContentDirectory.new('second_dev', 'second dev')]
    )}
    it 'apps should be non empty' do
      app_service.apps.should_not be_nil
    end

    it 'should find items by slug' do
      second = app_service.get 'second_app'
      second.description.should == 'second app'
    end
    it 'should find devs by slug' do
      second = app_service.get_dev 'second_dev'
      second.description.should == 'second dev'
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
