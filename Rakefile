require 'rspec/core/rake_task'
require 'helper'
require '8hourapp'
require 'fileutils'

directory 'log'
directory 'test/git_repo_data'


this_dir = File.dirname(__FILE__)

desc "Run tests"
RSpec::Core::RakeTask.new(:spec => ['log', :setup])  do |t|
  t.pattern = "./spec/*.rb" 
end

desc "Run coverage"
RSpec::Core::RakeTask.new(:coverage => ['log', :setup])  do |t|
  
  Dir.mkdir "coverage" unless File.directory? "coverage"

  rcov_options = %w{
  	    --exclude osx\/objc,gems\/,spec\/,features\/,seeds\/
	    --aggregate coverage/coverage.data
	    --text-report
	  }

  t.pattern = "./spec/*.rb" 
  t.rcov = true
  t.rcov_opts = rcov_options
end

task :submodule_init => 'test/git_repo_data' do
 sh "git submodule update --init" 
end

task :out_of_date do
 outofdate = File.join(this_dir, "test/git_repo_data/out_of_date_repo")
 exec_in("git reset --hard origin/master^", outofdate) 
end

task :test_repo_setup do
 test_repo_origin = File.join(this_dir, "test/test_repo_origin")
 uptodate = File.join(this_dir, "test/git_repo_data/up_to_date_repo")
 outofdate = File.join(this_dir, "test/git_repo_data/out_of_date_repo")
 meta_origin = File.join(this_dir, "test/data/meta_origin")
 meta = File.join(this_dir, "test/app_service_data/meta")
 
 sh "git clone #{test_repo_origin} #{uptodate}" unless File.directory?(uptodate) 
 sh "git clone #{test_repo_origin} #{outofdate}" unless File.directory?(outofdate)
 sh "git clone #{meta_origin} #{meta}" unless File.directory?(meta)
end

desc "Set up development environment"
task :setup => [:submodule_init, :test_repo_setup, :out_of_date, :copy_data] do
end

task :copy_data do
  FileUtils.cp_r "test/app_service_data", "data" unless File.directory? "data"  
end

desc "Runs 8hourapp application"
task :run => :setup do
  run Sinatra::Application.run!
end

