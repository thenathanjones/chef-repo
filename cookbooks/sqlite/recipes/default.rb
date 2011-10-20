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

sqlite_version = "sqlite-#{node[:sqlite][:version]}"
source_name = "sqlite-autoconf-#{node[:sqlite][:version]}"
source_package_name = "#{source_name}.tar.gz"
sqlite_download = "/tmp/#{source_package_name}"
remote_file sqlite_download do
  source "http://www.sqlite.org/#{source_package_name}"
  mode "0644"
  not_if "test -f #{sqlite_download}"
end
bash "install SQLite" do
  code <<-EOH
  tar -zxvf #{sqlite_download}
  cd #{source_name}
  ./configure --prefix=/opt/local/#{sqlite_version} ; make
  make install
  EOH
end
