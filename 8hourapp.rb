#!/usr/bin/env ruby
require 'sinatra'
require 'haml'
require File.join(File.dirname(__FILE__), "app", "app_service")

get '/' do
  haml :home, :locals =>{ :apps => AppService.apps }, :format => :html5
end
