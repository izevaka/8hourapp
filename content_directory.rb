class ContentDirectory

  attr_reader :name, :description, :slug, :body
  
  def initialize(name, description, slug=nil, body=nil)
    @name = name
    @description = description
    @slug = slug
    if !@slug
      @slug = name
    end
    @body = body
  end

  def ContentDirectory.from_directory(dir, slug)
    new_app = nil
    app_yaml_file = File.join(dir, 'info.yaml')
    if File.file? app_yaml_file
    
      app_yaml = YAML.load_file app_yaml_file
      name = app_yaml[app_yaml.keys[0]]["name"]
      
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
      new_app = ContentDirectory.new(name, description, slug, body)
    end
    new_app
  end
end


class App < ContentDirectory
  attr_reader :dev
end

class Dev < ContentDirectory
end
