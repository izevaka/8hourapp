require "rubygems"
require "bundler/setup"
require File.join(File.dirname(__FILE__), '..', '8hourapp')  
require 'rspec'
require 'rack/test'

set :environment, :test
set :run, false

describe '8hourapp App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end  
 
  $appservice = AppService.new(
  [
    App.new({:slug=>'app1', :description=>'desc1', :name=>'app1', :body=>"### Markdown heading
This is body of a markdown file", :dev_slug => 'dev1'}),
    App.new(:slug=>'app2', :name=>'app2', :description=>'desc2', :dev_slug => 'dev2')
  ], 
  [
    Dev.new(:slug=>'dev1', :description=>'desc1', :name=>'dev1', :body=>"### Developer"),
    Dev.new(:slug=>'dev2', :description=>'desc2')
  ])

  it "root should load main layout and home" do
    get '/'
    last_response.should be_ok
    last_response.body.should include("app1", "desc1", "app2", "desc2")
  end

  it "should link to app slug" do
    get '/'
    last_response.body.should include("<a href='apps/app1'")
    last_response.body.should include("<a href='apps/app2'")
  end
  it "should link to dev slug" do
    get '/'
    last_response.body.should include("<a href='devs/dev1'")
    last_response.body.should include("<a href='devs/dev2'")
  end
  it "should respond to individual apps" do
    get '/apps/app1'

    last_response.body.should include("html")
    last_response.body.should include("<h3>Markdown heading</h3>")
  end
  it "should respond to individual devs" do
    get '/devs/dev1'

    last_response.body.should include("html")
    last_response.body.should include("<h3>Developer</h3>")
  end
end
