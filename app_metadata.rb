require 'yaml'
require 'gitrepo'

class AppRepo
  def initialize(slug, repo_path)
    @slug = slug
    @repo_path = repo_path
  end
  attr_accessor :slug, :repo_path
end

class AppMetadata
  attr_reader :app_repos
  
  def initialize(app_yaml_path)
    @app_yaml_path = app_yaml_path
    reload!
    @meta_repo = GitRepo.new File.dirname(@app_yaml_path)
  end
  
  def check_updates!
   if @meta_repo.update!
     reload!
   end
  end

  def reload!
    app_repos = []

    apps_file = YAML.load_file @app_yaml_path
    apps_file["apps"].each do |slug, details|
      app_repos.push AppRepo.new(slug, details["repo"])
      #dev_config = details["dev"]
      #if dev_config
      #  dev_repos.push AppRepo.new(dev_config["slug"], dev_config["repo"])
      #end
    end
    @app_repos = app_repos
  end
end

