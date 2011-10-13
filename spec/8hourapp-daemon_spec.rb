$this_dir = File.dirname(__FILE__)
require 'rspec'
require 'fileutils'
require File.join($this_dir, '..', 'helper')
require_relative '../8hourapp-daemon-worker'


describe GitRepo do
  before(:all) do
    if File.directory?(File.join($this_dir, '../test/data'))
      FileUtils.rm_r File.join($this_dir, '../test/data')
    end
    FileUtils.cp_r File.join($this_dir, '../test/git_repo_data'), File.join($this_dir, '../test/data')
  end

  context 'On creation' do
    it 'should trow when initialized with non-git directory' do
      lambda { GitRepo.new File.join($this_dir, '../test') }.should raise_error InvalidRepoError
    end
  end

  context 'When checking if up to date' do
    let (:uptodate_repo) { GitRepo.new File.join($this_dir, '../test/data/up_to_date_repo') }
    let (:outofdate_repo) {GitRepo.new File.join($this_dir, '../test/data/out_of_date_repo') }
    it 'should be up to date for up to date repo' do
      uptodate_repo.should be_up_to_date

    end
    it 'should be not up to date for out of date repo' do
      outofdate_repo.should_not be_up_to_date
    end
  end
  context 'When updating repo' do
    let (:outofdate_repo) { GitRepo.new File.join($this_dir, '../test/data/out_of_date_repo')}
      
    it 'should change from out of date to up to date after update' do
      outofdate_repo.should_not be_up_to_date
      outofdate_repo.update!
      outofdate_repo.should be_up_to_date
    end
  end
end
