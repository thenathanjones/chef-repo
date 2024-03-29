#
# Cookbook Name:: sqlite
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

sqlite_version = "3070800"
sqlite_package_name = "sqlite-autoconf-#{sqlite_version}"
file_name = "#{sqlite_package_name}.tar.gz"
bash "install SQLite" do
  code <<-EOH
  cd /usr/local/src/
  wget http://www.sqlite.org/#{file_name}
  tar xzvf #{file_name}
  cd #{sqlite_package_name}
  ./configure
  make
  make install
  EOH
  not_if "test -d /usr/local/src/#{sqlite_package_name}"
end