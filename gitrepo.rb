require "rubygems"
require "bundler/setup"
class GitRepo
  def initialize(dir)
    @dir = dir
    if !File.directory? File.join(dir, '.git')
      raise InvalidRepoError,"#{dir} is not a git repository"
    end
  end

  def up_to_date?
    local_head = get_local_head
    remote_head = exec_in("git ls-remote origin HEAD", @dir).split[0]

    local_head == remote_head
  end
  def update!
    #pull from remote, then compare HEAD SHA1s to see if it's been updated.
    #This way checking for updates and pulling can be done with one server call
    local_head = get_local_head
    exec_in("git pull origin",@dir)
    local_head != get_local_head
  end
private
  def get_local_head
    exec_in("git rev-parse HEAD",@dir).strip
  end
end
