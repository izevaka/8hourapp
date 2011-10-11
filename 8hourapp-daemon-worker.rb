#checks main repository and keeps the app repositories up to date
require 'yaml'
require 'logger'

$Logger = Logger.new '/Users/izevaka/src/8hourapp/log/daemon.log', 'daily'
$Logger.level = Logger::DEBUG

class InvalidRepoError < Exception
end

class GitRepo
  def initialize(dir)
    @dir = dir
    if !File.directory? File.join(dir, '.git')
      raise InvalidRepoError,"#{dir} is not a git repository"
    end
  end

  def up_to_date?
    Dir.chdir @dir
    local_head = `git rev-parse HEAD`.strip
    remote_head = `git ls-remote origin HEAD`.split[0]

    #"local_head #{local_head}" + "remote_head #{remote_head}"
    local_head == remote_head
  end
  def update
    Dir.chdir @dir
    `git pull origin `
  end
end

class AppDaemon
end
