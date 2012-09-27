#
# Cookbook Name:: virgo
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

windows_zipfile "c:/virgo" do
  source node['virgo']['source']
  action :unzip
  not_if {File.exists?("c:/virgo/virgo-tomcat-server-3.0.3.RELEASE/bin/startup.bat")}
end