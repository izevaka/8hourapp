require File.join(File.dirname(__FILE__), '..', '8hourapp')  # <-- your sinatra app
require 'rspec'
require 'rack/test'

set :environment, :test

describe '8hourapp App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end  
  
  class AppService
    def AppService.apps
      [App.new('app1', 'desc1'),App.new('app2', 'desc2') ]
    end
  end
  
  it "root should load main layout and home" do
    get '/'
    last_response.should be_ok
    last_response.body.should include("app1", "desc1", "app2", "desc2")
  end

  it "should link to app slug"
end
