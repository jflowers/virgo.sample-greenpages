windows_package node['notepadplusplus']['package_name'] do
  source node['notepadplusplus']['url']
  action :install
end
