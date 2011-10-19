#
# Cookbook Name:: unicorn_nginx
# Recipe:: default
# Author:: Nathan Jones (thenathanjones@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ruby"

include_recipe "nginx"

packages = ["libxml2-devel", "libxslt-devel"]
packages.each do |p|
  package "#{p}" do
    action :install
  end
end

# create a user for running the application
user_home = "/home/#{node[:app][:user]}"
user "#{node[:app][:user]}" do
  comment "User for #{node[:app][:name]}"
  gid "#{node[:nginx][:group]}"
  home "#{user_home}"
  shell "/bin/bash"
end

# create the .ssh directory for keys
ssh_directory = "#{user_home}/.ssh"
directory "#{ssh_directory}" do
  mode 0700
  owner "#{node[:app][:user]}"
  group "#{node[:nginx][:group]}"
end

# add a specific set of keys to the authorized_keys file for logons
template "#{ssh_directory}/authorized_keys" do
  source "authorized_keys.erb"
  owner "#{node[:app][:user]}"
  group "#{node[:nginx][:group]}"
  mode 0600
end

# create the base directory the app will be deployed to
directory "#{node[:nginx][:working_dir]}" do
  mode 0755
  owner "#{node[:nginx][:user]}"
  group "#{node[:nginx][:group]}"
end

# override the existing template with one configured for unicorn
template "#{node[:nginx][:dir]}/sites-enabled/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode 0644
end

# include more config from the unicorn version of the nginx.conf file
template "#{node[:nginx][:dir]}/conf.d/upstream.conf" do
  source "upstream.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

# ensure the directory to deploy the app to is there
deploy_dir = "#{node[:nginx][:working_dir]}/#{node[:app][:name]}"
directory "#{deploy_dir}" do
  mode 0755
  owner "#{node[:app][:user]}"
  group "#{node[:nginx][:group]}"
  action :create
end

# ensure the log directory for unicorn is created and accessible
unicorn_log_dir = "/var/log/unicorn"
directory "#{unicorn_log_dir}" do
  mode 0755
  owner "#{node[:app][:user]}"
  group "#{node[:nginx][:group]}"
end

# install bundler and let the app deal with its own gems
bash "install bundler" do
  code <<-EOH
  gem install bundler --no-rdoc --no-ri
  EOH
end