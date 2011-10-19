#
# Cookbook Name:: go
# Recipe:: agent
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

package "go-server" do
  case node[:platform]
    when "CentOS","RedHat","Fedora"
      source "http://download01.thoughtworks.com/go/2.3.1/ga/go-agent-2.3.1-14065.noarch.rpm"
    else
      source "http://download01.thoughtworks.com/go/2.3.1/ga/go-agent-2.3.1-14065.deb"
    end
end

# template go-agent config
template "/etc/default/go-agent" do
  source "go-agent.erb"
  owner "go"
  group "go"
  mode "0644"
end

template_go_config

service "go-agent" do
  action :restart
end