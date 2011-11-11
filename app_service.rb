require 'yaml'
require File.join(File.dirname(__FILE__), "helper")
require 'content_directory'
require 'app_metadata'

class AppService
  
  attr_reader :apps, :devs
  
  def initialize(apps=nil, devs=nil)
    @apps = apps
    @devs = devs || []
  end

  def get(slug)
    return @apps.select {|a| a.slug == slug}.first
  end

  def get_dev(slug)
    return @devs.select {|a| a.slug == slug}.first
  end
  
  def AppService.load_from_file(root_dir)
    
    app_meta = AppMetadata.new "#{root_dir}/meta/apps.yaml"
    
    apps = self.load_content_dir root_dir,app_meta.app_repos
    AppService.new apps
  end

private
  def AppService.load_content_dir(root_dir, repo_list)
    apps= []
    
    repo_list.each do |app_meta|
      slug = app_meta.slug
      app_dir = "#{root_dir}/repos/#{slug}"
      if File.directory? app_dir
        app = App.from_directory(app_dir, slug)
        if app
          apps.push app
        end
      end
    end
    apps
  end
end
