#!/usr/bin/env ruby
require 'sinatra'
require 'haml'
require 'redcarpet'
require File.join(File.dirname(__FILE__), "app", "app_service")

$appservice = AppService.new

get '/' do
  haml :home, :locals =>{ :apps => $appservice.apps }, :format => :html5
end

get '/apps/:slug' do |slug|
  app = $appservice.get(slug)
  haml :app, :locals => {:app => app}, :format => :html5
end
