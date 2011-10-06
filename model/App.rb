class App

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
end
