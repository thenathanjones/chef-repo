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

include_recipe "unicorn"

package 'sqlite-devel'

gem_package 'rails'

directory "/var/www" do
  mode 0755
  owner "#{node[:nginx][:user]}"
  group "#{node[:nginx][:group]}"
end

port_setup = {8080 => {:tcp_nopush => true}, "'/tmp/.sock'" => {:backlog => 64}}
unicorn_config "/etc/unicorn" do
  working_directory "/var/www"
  listen port_setup
  owner "#{node[:nginx][:user]}"
  group "#{node[:nginx][:group]}"
  pid "/var/www/unicorn/tmp/pid/unicorn.pid"
  stderr_path "/var/www/unicorn/unicorn.error.log"
  stdout_path "/var/www/unicorn/unicorn.out.log"
end