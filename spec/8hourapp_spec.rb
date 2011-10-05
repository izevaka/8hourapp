require File.join(File.dirname(__FILE__), '../8hourapp')  # <-- your sinatra app
require 'rspec'
require 'rack/test'

set :environment, :test

describe '8hourapp App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should load main layout" do
    get '/'
    last_response.should be_ok
    puts last_response.body
    last_response.body.should include("<html>")
  end
end
