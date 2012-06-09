
file_cache_path "c:/tools/chef/cache"
cookbook_path [ "c:/tools/chef/cookbooks" ]
file_backup_path "c:/tools/chef/backup"
role_path "c:/tools/chef/roles"

json_attribs "http://10.153.10.173:8082/nexus/service/local/artifact/maven/redirect?r=thirdparty&g=com.agilex.chef&a=node&v=1.0&e=json"
recipe_url "http://10.153.10.173:8082/nexus/service/local/artifact/maven/redirect?r=thirdparty&g=com.agilex.chef&a=chef-solo-cookbooks&v=1.0&e=tar.gz"

log_level :debug
log_location STDOUT