require 'yaml'
require File.join(File.dirname(__FILE__), "helper")
require 'app'

class AppService
  
  attr_reader :apps
  
  def initialize(apps=nil)
    @apps = apps
  end

  def get(slug)
    return @apps.select {|a| a.slug == slug}.first
  end
  
  def AppService.load_from_file(root_dir)
    apps= []
    
    appmeta = AppMetadata.new app_file("#{root_dir}/meta/apps.yaml")
    appmeta.app_repos.each do |app_meta|
      slug = app_meta.slug
      app_dir = app_file("#{root_dir}/repos/#{slug}")
      if File.directory? app_dir
        app = load_app_from_dir(app_dir, slug)
        if app
          apps.push app
        end
      end
    end
    
    AppService.new apps 
  end

private
  def AppService.load_app_from_dir(dir, slug)
    app_yaml_file = File.join(dir, 'app.yaml')
    if File.file? app_yaml_file
      app_yaml = YAML.load_file app_yaml_file
      name = app_yaml["app"]["name"]
      
      desc_file = File.join(dir, 'description.md')
      description = nil
      if File.file? desc_file
        description = File.read desc_file
      end

      body_file = File.join(dir, 'body.md')
      body = nil
      if File.file? body_file
        body = File.read body_file 
      end
      
      App.new(name, description, slug, body)
    end
  end

end
