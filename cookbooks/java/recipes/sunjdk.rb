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

package "go-server" do
  case node[:platform]
    when "centos","redhat","fedora"
      source "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-i586.rpm"
    else
      source ""
    end
end