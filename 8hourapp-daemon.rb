require "rubygems"
require "bundler/setup"
#!/usr/bin/env ruby -rubygems
#daemon runner
require 'daemons'
require File.join(File.dirname(__FILE__), "helper")
require_relative "8hourapp-daemon-worker"
logger.debug "Initializing AppDaemon with #{relative("data")}"
AppDaemon.new(relative("data"), true).run
