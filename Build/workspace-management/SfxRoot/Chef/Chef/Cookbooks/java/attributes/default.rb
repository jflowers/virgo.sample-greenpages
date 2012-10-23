#
# Cookbook Name:: java
# Attributes:: default 
#
# Copyright 2012, Agilex
#
# All rights reserved - Do Not Redistribute
#


case platform
when "windows"
  default['java']['java_home'] = 'C:\\Java\\jdk1.7.0_4'
  default['java']['url'] = 'http://jayflowers.com/Misc%20Downloads/jdk-7u4-windows-x64.exe'
  default['java']['checksum'] = '203a0e484e25ac6b2950ec75de2c106c3aeaf115'
else

end