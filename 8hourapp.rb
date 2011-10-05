#!/usr/bin/env ruby
require 'sinatra'
require 'haml'

get '/' do
  haml "Here are them apps"
end
