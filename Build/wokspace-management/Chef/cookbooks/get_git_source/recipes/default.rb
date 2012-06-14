#
# Cookbook Name:: get_git_source
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

dir = node['get_git_source']['dir']

directory dir do
  inherits true
  recursive true
  action :create
end

ruby_block "clone_git_repo" do
  block do
    url = node['get_git_source']['url']
	Chef::Log.info("Cloning the repo #{url} to directory #{dir}, this could take a while...")
	git = Chef::ShellOut.new("git clone #{url} #{dir}")
	git.run_command
	puts git.stdout
	if git.stderr != ''
	  puts "error messages: " + git.stderr
	end
	# Raise an exception if it didn't exit with 0
	git.error!
  end
  action :create
  not_if do
	Chef::Log.info("Checking if #{dir} is a working git repo")
    git = Chef::ShellOut.new("git status", :cwd => dir)
	git.run_command
	puts git.stdout
	if git.stderr != ''
	  puts git.stderr
	end
	if git.exitstatus == 0
		true
	else
		false
	end
  end
end