require 'rspec/core/rake_task'
require 'helper'

directory 'log'
directory 'test/git_repo_data'

desc "Run specs" => :setup
RSpec::Core::RakeTask.new(:spec=>['log', :setup])  do |t|
  t.pattern = "./spec/*.rb" 
  # Put spec opts in a file named .rspec in root
end


task :submodule_init => 'test/git_repo_data' do
 sh "git submodule update --init" 
end

task :out_of_date do
 this_dir = File.dirname(__FILE__)
 outofdate = File.join(this_dir, "test/git_repo_data/out_of_date_repo")
 exec_in("git reset --hard master^", outofdate) 
end

task :test_repo_setup do
 this_dir = File.dirname(__FILE__)
 test_repo_origin = File.join(this_dir, "test/test_repo_origin")
 uptodate = File.join(this_dir, "test/git_repo_data/up_to_date_repo")
 outofdate = File.join(this_dir, "test/git_repo_data/out_of_date_repo")
 
 sh "git clone #{test_repo_origin} #{uptodate}" unless File.directory?(uptodate) 
 sh "git clone #{test_repo_origin} #{outofdate}" unless File.directory?(outofdate)

end


task :setup => [:submodule_init, :test_repo_setup, :out_of_date] do
end

