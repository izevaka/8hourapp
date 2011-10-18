#!/usr/bin/env ruby
require 'sinatra'
require 'haml'
require 'redcarpet'
require File.join(File.dirname(__FILE__), "helper")
require 'app_service'

def appservice
  if !$appservice
    $appservice = AppService.load_from_file 'data'
  end
  $appservice
end

before do
  expires 30, :public, :must_revalidate
end

get '/' do
  puts "rendering home"
  haml :home, :locals =>{ :apps => appservice.apps }, :format => :html5
end

get '/apps/:slug' do |slug|
  app = appservice.get(slug)
  haml :app, :locals => {:app => app}, :format => :html5
end
