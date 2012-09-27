#
# Cookbook Name:: sysinternals
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

directory 'c:/Tools/Sysinternals' do
  inherits true
  recursive true
  action :create
end

windows_zipfile "c:/Tools/Sysinternals" do
  source node['sysinternals']['source']
  action :unzip
  not_if {File.exists?("c:/Tools/Sysinternals/procexp.exe")}
end

cookbook_file "#{ENV['TEMP']}/ProcessExplorer.reg" do
  source 'ProcessExplorer.reg'
end

execute "regedit" do
  command "C:\\Windows\\SysWOW64\\regedit.exe /s #{ENV['TEMP']}/ProcessExplorer.reg"
  action :run
end