class ContentDirectory

  attr_reader :name, :description, :slug, :body
  

  def initialize(hash)
    @name = hash[:name] 
    @description = hash[:description]
    @slug = hash[:slug]
    @body = hash[:body]
    if (hash[:yaml_file])
      yaml = YAML.load_file hash[:yaml_file]
      dir = File.dirname(hash[:yaml_file])
      @name = yaml[yaml.keys[0]]["name"]
    
      desc_file = File.join(dir, 'description.md')
      description = nil
      if File.file? desc_file
        @description = File.read desc_file
      end

      body_file = File.join(dir, 'body.md')
      if File.file? body_file
        @body = File.read body_file 
      end
      init(yaml)
    end
  end
protected
  
  def init
  end

  def self.create_from_directory(dir, slug, theClass)
    new_app = nil
    app_yaml_file = File.join(dir, 'info.yaml')
    if File.file? app_yaml_file
      new_app = theClass.new :yaml_file => app_yaml_file, :slug => slug
    end
    new_app
  end
end


class App < ContentDirectory
  attr_reader :dev_slug

  def initialize(hash)
    super hash
    @dev_slug = hash[:dev_slug]
  end
  def self.from_directory(dir, slug)
    ContentDirectory.create_from_directory dir, slug, self
  end
protected
  def init(yaml)
    dev = yaml[yaml.keys[0]]["dev"]
    if (dev)
      @dev_slug = dev["slug"]
    end
  end
end

class Dev < ContentDirectory
  def self.from_directory(dir, slug)
    ContentDirectory.create_from_directory dir, slug, self
  end
end
