#
# Cookbook Name:: go
# Recipe:: server
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

package "git-core"

case node[:platform]
when "centos","redhat","fedora"
  package_name = "go-server-2.3.1-14065.noarch.rpm"
  go_download = "/tmp/#{package_name}"
  remote_file go_download do
    source "http://download01.thoughtworks.com/go/2.3.1/ga/#{package_name}"
    mode "0644"
    owner "#{ENV['USER']}"
    group "#{ENV['USER']}"
    not_if "test -f #{go_download}"
  end
  
  execute "go install" do
    command "yum -d0 -e0 -y localinstall #{go_download} --nogpgcheck"
  end
else
  package_name = "go-server-2.3.1-14065.deb"
  go_download = "/tmp/#{package_name}"
  remote_file go_download do
    source "http://download01.thoughtworks.com/go/2.3.1/ga/#{package_name}"
    mode "0644"
    owner "#{ENV['USER']}"
    group "#{ENV['USER']}"
    not_if "test -f #{go_download}"
  end
  
  package "go" do
    source "#{go_download}"
  end
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

# template go-server config
template "/etc/default/go-server" do
  source "go-server.erb"
  owner "go"
  group "go"
  mode "0644"
end

service "go-server" do
  action :stop
end

template_go_config do
  config node[:go]
end

service "go-server" do
  action :start
end