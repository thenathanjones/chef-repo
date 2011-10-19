#
# Cookbook Name:: java
# Recipe:: sunjdk
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

case node[:platform]
when "centos","redhat","fedora"
  package_name = "jdk-7-linux-i586.rpm"
  jdk_download = "/tmp/#{package_name}"
  remote_file jdk_download do
    source "http://download.oracle.com/otn-pub/java/jdk/7/#{package_name}"
    mode "0644"
    owner "#{ENV['USER']}"
    group "#{ENV['USER']}"
    not_if "test -f #{jdk_download}"
  end
  
  package "jdk" do
    source "#{jdk_download}"
  end
else
  raise "Platform not supported...yet"
end