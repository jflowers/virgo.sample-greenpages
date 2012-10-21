
require 'minitest-chef-handler'

file_cache_path "c:/tools/chef/cache"
cookbook_path [File.dirname(__FILE__) + "/Chef/cookbooks"]
file_backup_path "c:/tools/chef/backup"
role_path "c:/tools/chef/roles"

json_attribs File.dirname(__FILE__) + "/node.json"

handler = MiniTest::Chef::Handler.new(:path => File.join(Chef::Config[:cookbook_path], "*", "test", "*test*.rb"))
report_handlers << handler

log_level :debug
log_location STDOUT