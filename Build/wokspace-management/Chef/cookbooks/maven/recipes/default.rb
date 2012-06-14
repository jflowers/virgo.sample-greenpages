#
# Cookbook Name:: maven
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory 'c:/Tools/maven' do
  inherits true
  recursive true
  action :create
end

remote_file "#{ENV['TEMP']}\\maven.zip" do
  source node['maven']['source']
  not_if {File.exists?("c:/Tools/maven/apache-maven-2.2.1/bin/mvn.bat")}
end

execute "uzip" do
  command "C:\\java\\jdk1.7.0_4\\bin\\jar.exe xf #{ENV['TEMP']}\\maven.zip"
  cwd "c:/Tools/maven"
  creates "c:/Tools/maven/apache-maven-2.2.1/bin/mvn.bat"
  action :run
end