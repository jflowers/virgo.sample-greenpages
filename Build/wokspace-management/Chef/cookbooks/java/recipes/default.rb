#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

windows_package "java" do
  source node['java']['url']
  checksum node['java']['checksum']
  action :install
  installer_type :custom
  options "/s /v \"/qn INSTALLDIR=#{node['java']['java_home']}\""
  not_if { File.directory? node['java']['java_home'] }
end
