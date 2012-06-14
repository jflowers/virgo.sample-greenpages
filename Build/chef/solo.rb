
file_cache_path "c:/tools/chef/cache"
cookbook_path [ File.dirname(__FILE__) + "/../workspace-management/Chef/cookbooks" ]
file_backup_path "c:/tools/chef/backup"
role_path "c:/tools/chef/roles"

json_attribs File.dirname(__FILE__) + "/../workspace-management/Chef/node.json"

log_level :debug
log_location STDOUT