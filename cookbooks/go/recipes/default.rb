#
# Cookbook Name:: go
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

include_recipe "java"

# download Go server and agent
go_server = "go-server-2.3.0-14056.deb"
go_server_download = "/tmp/#{go_server}"
remote_file go_server_download do
  source "http://download01.thoughtworks.com/go/2.3/ga/#{go_server}"
  mode "0644"
  owner "#{ENV['USER']}"
  group "#{ENV['USER']}"
  not_if "test -f #{go_server_download}"
end
go_agent = "go-agent-2.3.0-14056.deb"
go_agent_download = "/tmp/#{go_agent}"
remote_file go_agent_download do
  source "http://download01.thoughtworks.com/go/2.3/ga/#{go_agent}"
  mode "0644"
  owner "#{ENV['USER']}"
  group "#{ENV['USER']}"
  not_if "test -f #{go_agent_download}"
end

# install Go server
execute "install Go server" do
  command "dpkg -i #{go_server_download}"
  not_if "test -d /etc/go-server"
end

# install Go agent
execute "install Go agent" do
  command "dpkg -i #{go_agent_download}"
  not_if "test -d /etc/go-agent"
end

# create the artifacts directory
artifacts_dir = '/var/artifacts'
directory artifacts_dir do
  owner "go"
  group "go"
  mode "0755"
  action :create
  not_if "test -d #{artifacts_dir}"
end

# template go-agent config
template "/etc/default/go-agent" do
  source "go-agent.erb"
  owner "go"
  group "go"
  mode "0644"
end

# template go-server config
template "/etc/default/go-server" do
  source "go-server.erb"
  owner "go"
  group "go"
  mode "0644"
end

template_go_config

execute "start Go Server" do
  command "service go-server start"
  ignore_failure true
end

execute "start Go Agent" do
  command "service go-agent start"
  ignore_failure true
end