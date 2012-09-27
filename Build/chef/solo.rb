
file_cache_path "c:/tools/chef/cache"
cookbook_path [ File.dirname(__FILE__) + "/../workspace-management/SfxRoot/Chef/Chef/Cookbooks" ]
file_backup_path "c:/tools/chef/backup"
role_path "c:/tools/chef/roles"

json_attribs File.dirname(__FILE__) + "/../workspace-management/SfxRoot/Chef/node.json"

log_level :debug
log_location STDOUT