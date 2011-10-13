#checks main repository and keeps the app repositories up to date
require 'yaml'
require 'logger'
require 'gitrepo'

$Logger = Logger.new '/Users/izevaka/src/8hourapp/log/daemon.log', 'daily'
$Logger.level = Logger::DEBUG

class InvalidRepoError < Exception
end

class AppDaemon
  def initialize(apps_root, do_loop = false)
    @do_loop = do_loop
    @apps_root = apps_root

    @app_meta = AppMetada.new "#{apps_root}/meta/apps.yaml"
    update_apps
  end

  def run
    logger.info "Starting app daemon #{@do_loop ? "with " : "without "} looping"
    if do_loop
      loop do
        process_repos
      end
    elsif
      process_repos
    end
  end
private
  def process_repos 
    
    if !@app_meta.up_to_date?
      @app_meta.update!
      update_apps
    end
  end
  
  def update_apps
    @app_repos = []
     @app_meta.app_repos.each do |app|
      repo_path = "#{@apps_root}/repos/#{app.slug}"
      if !File.file? repo_path
        FileUtils.chdir "#{@apps_root}/repos"
        `git clone #{@app.repo} #{@app.slug}`
      end
      @app_repos.push GitRepo.new(repo_path)
    end
  end
end


