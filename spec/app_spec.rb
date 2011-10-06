require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'app', 'app_service') 

describe AppService do
  app_service = AppService.new
  app_service.apps = [App.new('first', 'first'), App.new('second', 'second')] 
  it 'apps should be non empty' do
    app_service.apps.should_not be_nil
  end

  it 'should find items by slug' do
    second = app_service.get 'second'
    second.description.should == 'second'
  end
end
