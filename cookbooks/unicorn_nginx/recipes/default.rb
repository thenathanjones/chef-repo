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
deploy_dir = "#{node[:nginx][:working_dir]}/#{node[:app_name]}"
directory "#{deploy_dir}" do
  mode 0755
  owner "#{node[:nginx][:user]}"
  group "#{node[:nginx][:group]}"
  action :create
  recursive true
end

# ensure the log directory for unicorn is created
unicorn_log_dir = "/var/log/unicorn"
directory "#{unicorn_log_dir}" do
  mode 0755
  owner "#{node[:nginx][:user]}"
  group "#{node[:nginx][:group]}"
end

# install bundler and let the app deal with its own gems
bash "install bundler" do
  code <<-EOH
  gem install bundler --no-rdoc --no-ri
  EOH
end