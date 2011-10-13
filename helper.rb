unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path)
    end
  end
end

def app_dir
  File.dirname(__FILE__)
end

def relative(path)
  File.join(File.dirname(caller[0]), path)
end
