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
include_recipe "sqlite"

required_packages = ["git-core"]
required_packages.each do |p|
  package "#{p}"
end

case node[:platform]
when "centos","redhat","fedora"
  package_name = "go-agent-2.3.1-14065.noarch.rpm"
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
  package_name = "go-agent-2.3.1-14065.deb"
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

# template go-agent config
template "/etc/default/go-agent" do
  source "go-agent.erb"
  owner "go"
  group "go"
  mode "0644"
end

bash "install ruby-build" do
  code <<-EOH
  git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
  cd /tmp/ruby-build
  ./install.sh
  EOH
end

bash "install rbenv" do
  user "go"
  code <<-EOH
  git clone git://github.com/sstephenson/rbenv.git /var/go/.rbenv
  EOH
  not_if "test -d /var/go/.rbenv"
end

# add rbenv to the servers .bashrc file
template "/var/go/.bashrc" do
  source "agent-bashrc.erb"
  owner "go"
  group "go"
  mode "0644"
end

ruby_version = "#{node[:ruby][:version]}-#{node[:ruby][:patch_level]}"
bash "install ruby version - #{ruby_version}" do
  user "go"
  code <<-EOH
  export HOME=/var/go
  source /var/go/.bashrc
  rbenv install #{ruby_version}
  rbenv rehash
  rbenv global #{ruby_version}
  EOH
end

# install bundler and let the agents deal with their own gems
bash "install bundler" do
  user "go"
  code <<-EOH
  export HOME=/var/go
  source /var/go/.bashrc
  gem install bundler --no-rdoc --no-ri
  EOH
end

bash "creating SSH key" do
  user "go"
  code <<-EOH
  ssh-keygen -N '' -f /var/go/.ssh/id_rsa -t rsa -q
  EOH
end

service "go-agent" do
  action :restart
end