user "apache" do
    comment "Apache User"
    action :create
end

group "apache" do
    action :create
    members ['apache']
end

package "git" do
    action [:install]
end

package "httpd" do
    action [:install]
end

service "httpd"

directory "/var/gitrepo" do
    group "apache" 
    owner "apache" 
    mode "0775"
    action :create
end


template "/etc/httpd/conf/httpd.conf" do
    source "httpd.conf"
    notifies :restart, "service[httpd]"
end

cookbook_file "/var/gitrepo/htpasswd" do
    source "htpasswd"
    group "apache" 
    owner "apache" 
    mode "0775"
end

%w{repo1 repo2}.each do |repo|
    execute "create_repo" do
        command "git init --bare /var/gitrepo/#{repo}.git"
        creates "/var/gitrepo/#{repo}.git"
        action :run
    end

    template "/etc/httpd/conf.d/#{repo}.conf" do
        group "apache" 
        owner "apache" 
        mode "0775"
        source "gitrepo.conf"
        variables(
            :repo => repo,
            :passwd => "/var/gitrepo/htpasswd"
        )

        notifies :restart, "service[httpd]"
    end

    execute "chown_gitrepo" do
        command "chown -R apache:apache /var/gitrepo/#{repo}.git"
    end

    execute "generate-dumb-server-info" do
        cwd "/var/gitrepo/#{repo}.git"
        command "sudo -u apache git update-server-info"
        creates "/var/gitrepo/#{repo}.git/objects/info/packs"
    end

    execute "enable-dumb-server-hooks" do
        cwd "/var/gitrepo/#{repo}.git"
        command "mv /var/gitrepo/#{repo}.git/hooks/post-update.sample /var/gitrepo/#{repo}.git/hooks/post-update"
        creates "/var/gitrepo/#{repo}.git/hooks/post-update"
    end
end
