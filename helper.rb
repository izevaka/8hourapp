unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path)
    end
  end
end

def app_dir(path)
  return File.join(File.dirname(__FILE__), path)
end

def relative(path)
  File.join(File.expand_path(File.dirname(caller[0])), path)
end
