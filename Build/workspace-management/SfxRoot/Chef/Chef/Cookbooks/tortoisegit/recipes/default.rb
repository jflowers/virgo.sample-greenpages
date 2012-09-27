#
# Cookbook Name:: tortoisegit
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

windows_package node['tortoisegit']['package_name'] do
	source node['tortoisegit']['msi_source']
	checksum node['tortoisegit']['msi_checksum']
	action :install
	options '/norestart'
end