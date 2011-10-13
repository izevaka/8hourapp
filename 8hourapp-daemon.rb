#!/usr/bin/env ruby
#daemon runner
require 'daemons'
require File.join(File.dirname(__FILE__), "helper")
require_relative "8hourapp-daemon-worker"

AppDaemon.new(relative("data"), true).run
