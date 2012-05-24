require 'rspec/core/rake_task'
require 'helper'
require '8hourapp'

directory 'log'
directory 'test/git_repo_data'
directory 'coverage_report'

this_dir =  Rake.application.original_dir
test_repo_origin = File.join(this_dir, "test/test_repo_origin")
meta_origin = File.join(this_dir, "test/data/meta_origin")

desc "Run tests"
RSpec::Core::RakeTask.new(:spec => [:setup])  do |t|
  t.pattern = "./spec/*.rb" 
end

desc "Run coverage"
RSpec::Core::RakeTask.new(:coverage => [:setup, "coverage_report"])  do |t|
  rcov_options = %w{
  	   --exclude osx\/objc,gems\/,spec\/,features\/,seeds\/
	    --aggregate coverage_report/coverage.data
	    --text-report
      --output coverage_report
	  }

  t.pattern = "./spec/*.rb" 
  t.rcov = true
  t.rcov_opts = rcov_options
end

task :submodule_init => 'test/git_repo_data' do
 sh "git submodule update --init" 
end

task :out_of_date => "test/git_repo_data/out_of_date_repo" do |t|
 exec_in("git reset --hard origin/master^", t.prerequisites.first) 
end

file "test/git_repo_data/up_to_date_repo" do |t|
  git_clone  test_repo_origin, t.name
end

file "test/git_repo_data/out_of_date_repo" do |t|
  git_clone  test_repo_origin, t.name
end

file "test/app_service_data/meta" do |t|
  git_clone  test_origin, t.name
end


desc "Set up development environment"
task :setup => [:submodule_init, "test/git_repo_data/up_to_date_repo", :out_of_date, "test/app_service_data/meta", "log"] do
end

file "data" do
  cp_r "test/app_service_data", "data"
end

rule 

desc "Runs 8hourapp application"
task :run => [:setup, "data"] do
  run Sinatra::Application.run!
end


def git_clone(source, dest)
  sh "git clone #{source} #{dest}" 
end

