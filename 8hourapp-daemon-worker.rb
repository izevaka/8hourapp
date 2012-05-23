require "rubygems"
require "bundler/setup"
#checks main repository and keeps the app repositories up to date
$this_dir = File.dirname(__FILE__)
require File.join(File.dirname(__FILE__), "helper")
require 'yaml'
require 'logger'
require 'fileutils'
require_relative 'gitrepo'
require_relative 'app_metadata'


$logger = Logger.new File.join($this_dir, 'log/daemon.log'), 'daily'
$logger.level = Logger::DEBUG

def logger
  $logger
end
class InvalidRepoError < Exception
end

class AppDaemon
  def initialize(apps_root, do_loop = false)
    @do_loop = do_loop
    @apps_root = apps_root

    @app_meta = AppMetadata.new "#{apps_root}/meta/apps.yaml"
    refresh_apps
  end

  def run
    logger.info "Starting app daemon #{@do_loop ? "with " : "without "} looping"
    if @do_loop
      loop do
        update_apps
        sleep(5)
      end
    elsif
      update_apps
    end
  end
private
  def update_apps
    @app_meta.check_updates!
    @app_repos.each do |app|
      app.update!
    end
  end

  def refresh_apps
     @app_repos = []
     @app_meta.app_repos.each do |app|
      repo_path = "#{@apps_root}/repos/#{app.slug}"
      if !File.directory? repo_path
        begin
          FileUtils.chdir "#{@apps_root}/repos"
          `git clone #{app.repo_path} #{app.slug}`
          @app_repos.push GitRepo.new(repo_path)
        rescue
          logger.error "Could not clone repository #{app.repo_path}. #{$!}"
        end
      elsif
        begin 
          @app_repos.push GitRepo.new(repo_path)
        rescue :InvalidRepoError
          logger.info "repository in #{repo_path} is invalid"
        end
      end
    end
  end
end


