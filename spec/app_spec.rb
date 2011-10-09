require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'app_service') 

describe AppService do
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
    app_service = AppService.load_from_file 'test'
    
    it 'should contain two apps from the file' do
      app_service.apps[0].slug.should == "app1"
    end

    it 'should load names from app.yaml' do
      app_service.apps[0].name.should == 'Rates Tracker'
    end
    it 'should load description from description.md' do
      app_service.apps[0].description.should == "Allows you to track rates.\n"
    end
    it 'should load body from body.md' do
      app_service.apps[0].body.should == "Allows you to track rates.\nFull description\n"
    end
  end
end
