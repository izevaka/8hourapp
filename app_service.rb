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
    
    apps_file = YAML.load_file app_file("#{root_dir}/meta/apps.yaml")
    apps_file["apps"].each do |slug, value|
      app_dir = app_file("#{root_dir}/repos/#{slug}")
      apps.push load_app_from_dir(app_dir, slug)
    end
    
    AppService.new apps 
  end

private
  def AppService.load_app_from_dir(dir, slug)
    app_yaml = YAML.load_file File.join(dir, 'app.yaml')
    name = app_yaml["app"]["name"]
    description = File.read File.join(dir, 'description.md')
    body = File.read File.join(dir, 'body.md')
    App.new(name, description, slug, body)
  end

end
