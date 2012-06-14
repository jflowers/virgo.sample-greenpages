#
# Cookbook Name:: tortoisegit
# Recipe:: default
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#

if kernel['machine'] =~ /x86_64/
  default['tortoisegit']['msi_source'] = "http://tortoisegit.googlecode.com/files/TortoiseGit-1.7.10.0-64bit.msi"
  default['tortoisegit']['msi_checksum'] = "109c49c0a70922d93ff2b134ece938384f7efc1c"
  default['tortoisegit']['package_name'] = "TortoiseGit 1.7.10.0 (64 bit)"
else
  default['tortoisegit']['msi_source'] = "http://tortoisegit.googlecode.com/files/TortoiseGit-1.7.10.0-32bit.msi"
  default['tortoisegit']['msi_checksum'] = "c55d6e86abb3590666fa3d75e527369def378264"
  default['tortoisegit']['package_name'] = "TortoiseGit 1.7.10.0 (32 bit)"
end