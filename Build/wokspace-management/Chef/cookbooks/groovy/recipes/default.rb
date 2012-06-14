#
# Cookbook Name:: groovy
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory 'c:/Tools/groovy' do
  inherits true
  recursive true
  action :create
end

remote_file "#{ENV['TEMP']}\\groovy.zip" do
  source node['groovy']['source']
  not_if {File.exists?("c:/Tools/groovy/groovy-1.8.6/bin/groovy.bat")}
end

execute "uzip" do
  command "C:\\java\\jdk1.7.0_4\\bin\\jar.exe xf #{ENV['TEMP']}\\groovy.zip"
  cwd "c:/Tools/groovy"
  creates "c:/Tools/groovy/groovy-1.8.6/bin/groovy.bat"
  action :run
end