require File.join(File.dirname(__FILE__), "..", "model", "app")


class AppService
  
  attr_accessor :apps
  
  def initialize
    @apps = [
      App.new('app1', 'desc1', 'app1', 
'### Fully sick App1
paragraph 1  

paragraph 2
'),
      App.new('app2', 'desc2', 'app2', 
'### Fully sick App2
paragraph 1  

paragraph 2
')
  ]
  end

  def get(slug)
    return @apps.select {|a| a.slug == slug}.first
  end
end
