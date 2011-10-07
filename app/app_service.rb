require 'yaml'
require File.join(File.dirname(__FILE__), "..", "model", "app")


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
    
    apps_file = YAML.load_file File.join(File.dirname(__FILE__), '..', root_dir,'meta', 'apps.yaml')
    apps_file["apps"].each do |slug, value|
      app_dir = File.join(File.dirname(__FILE__), '..', root_dir,'repos', slug)
      apps.push load_app_from_dir(app_dir, slug)
    end
    
    AppService.new apps 
  end

private
  def AppService.load_app_from_dir(dir, slug)
    app_yaml = YAML.load_file File.join(dir, 'app.yaml')
    name = app_yaml["app"]["name"]
    App.new(name, nil, slug, nil)
  end

end
