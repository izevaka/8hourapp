require File.join(File.dirname(__FILE__), "..", "model", "app")


class AppService
  def AppService.apps
    [App.new('app1', 'desc1'),App.new('app2', 'desc2') ]
  end
end
