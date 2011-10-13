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
   if !@meta_repo.up_to_date?
     @meta_repo.update!
     reload!
   end
  end

  def reload!
    repos = []

    apps_file = YAML.load_file @app_yaml_path
    apps_file["apps"].each do |slug, details|
      repos.push AppRepo.new(slug, details["repo"])
    end
    @app_repos = repos
  end
end

