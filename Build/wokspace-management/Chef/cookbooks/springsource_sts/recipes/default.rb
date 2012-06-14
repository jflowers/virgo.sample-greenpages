#
# Cookbook Name:: springsource_sts
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

windows_zipfile "c:/Program Files" do
  source node['springsource_sts']['source']
  action :unzip
  not_if {File.exists?("c:/Program Files/springsource/sts-2.9.2.RELEASE/STS.exe")}
end