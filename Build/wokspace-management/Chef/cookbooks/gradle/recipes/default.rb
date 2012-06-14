#
# Cookbook Name:: gradle
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

directory 'c:/Tools/gradle' do
  inherits true
  recursive true
  action :create
end

windows_zipfile "c:/Tools/gradle" do
  source node['gradle']['source']
  action :unzip
  not_if {File.exists?("c:/Tools/gradle/gradle-1.0-rc-3/bin/gradle.bat")}
end