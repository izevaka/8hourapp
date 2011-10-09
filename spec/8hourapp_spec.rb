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
 
  $appservice = AppService.new [
    App.new('app1', 'desc1', 'app1', "
### Markdown heading
This is body of a markdown file      
    "),
    App.new('app2', 'desc2')
  ]
  
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
  it "should respond to individual apps" do
    get '/apps/app1'

    last_response.body.should include("html")
    last_response.body.should include("<h3>Markdown heading</h3>")
  end
end
