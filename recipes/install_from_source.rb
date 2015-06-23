#
# Cookbook Name:: qubit-bamboo
# Recipe:: default
#
#
# Copyright 2015, Criteo
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

include_recipe 'yum-epel'

package 'golang'
package 'git'

tar = ::File.join(Chef::Config[:file_cache_path], "qubit_bamboo_#{node['qubit_bamboo']['version']}.tar.gz")
gopath = ::File.join(Chef::Config[:file_cache_path], 'go')
go_link = ::File.join(gopath, 'src', 'github.com', 'QubitProducts')

directory node['qubit_bamboo']['home'] do
  recursive true
end

remote_file tar do
    source "https://github.com/QubitProducts/bamboo/archive/v#{node['qubit_bamboo']['version']}.tar.gz"
    notifies :run, 'bash[untar_bamboo]', :immediately
end

bash 'untar_bamboo' do
  cwd "#{Chef::Config[:file_cache_path]}/"
  code <<-EOF
  tar xzf #{tar}
  EOF
  action :nothing
  notifies :run, 'bash[build_bamboo]', :immediately
end

bash 'build_bamboo' do
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOF
  mkdir -p #{go_link}
  [ -l #{go_link}/bamboo ] || ln -s $(pwd)/bamboo-#{node['qubit_bamboo']['version']}  #{go_link}/bamboo
  export GOPATH=#{gopath}
  cd bamboo-#{node['qubit_bamboo']['version']}
  go build
  EOF
  action :nothing
end

execute 'copy_bamboo_binary' do
  command "cp #{Chef::Config[:file_cache_path]}/bamboo-#{node['qubit_bamboo']['version']}/bamboo-#{node['qubit_bamboo']['version']} #{node['qubit_bamboo']['home']}/bamboo"
  action :nothing
  subscribes :run, 'bash[build_bamboo]', :immediately
end

file "#{node['qubit_bamboo']['home']}/bamboo" do
  mode 0755
end

directory "#{node['qubit_bamboo']['home']}/webapp" do
  recursive true
end

file "#{node['qubit_bamboo']['home']}/VERSION" do
  content node['qubit_bamboo']['version']
end

bash 'copy_bamboo_webapp' do
  cwd ::File.join(Chef::Config[:file_cache_path], "bamboo-#{node['qubit_bamboo']['version']}")
  code <<-EOF
  cp -rp webapp/dist #{node['qubit_bamboo']['home']}/webapp/dist
  cp -rp webapp/fonts #{node['qubit_bamboo']['home']}/webapp/fonts
  cp webapp/index.html #{node['qubit_bamboo']['home']}/webapp/index.html
  EOF
  action :nothing
  subscribes :run, 'bash[build_bamboo]', :delayed
end

template '/etc/init/bamboo-server.conf' do
  source 'bamboo-server.conf.erb'
end
