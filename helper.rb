unless Kernel.respond_to?(:require_local)
  module Kernel
    def require_local(path)
      require File.join(File.dirname(__FILE__), path)
    end
  end
end

def app_dir
  File.dirname(__FILE__)
end


def app_file(file)
  File.join(app_dir, file)
end
