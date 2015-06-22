#
# Cookbook Name:: qubit-bamboo
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
yum_repository 'epel' do
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  description 'Extra Packages for Enterprise Linux 5 - $basearch'
  enabled true
  gpgcheck true
  gpgkey 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
end

package 'golang'
package 'git'

tar = ::File.join(Chef::Config[:file_cache_path], "qubit_bamboo_#{node['qubit_bamboo']['version']}.tar.gz")
remote_file tar do
  source "https://github.com/QubitProducts/bamboo/archive/v#{node['qubit_bamboo']['version']}.tar.gz"
end

bash 'untar_bamboo' do
  cwd "#{Chef::Config[:file_cache_path]}/"
  code <<-EOF
  tar xzf #{tar}
  EOF
end

directory node['qubit_bamboo']['home'] do
  recursive true
end

gopath = ::File.join(Chef::Config[:file_cache_path], 'go')
go_link = ::File.join(gopath, 'src', 'github.com', 'QubitProducts')
directory go_link do
  recursive true
end

bash 'build_bamboo' do
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOF
  [ -l #{go_link}/bamboo ] || ln -s $(pwd)/bamboo-#{node['qubit_bamboo']['version']}  #{go_link}/bamboo
  export GOPATH=#{gopath}
  cd bamboo-#{node['qubit_bamboo']['version']}
  go build
  EOF
end
execute 'copy_bamboo_binary' do
  command "cp #{Chef::Config[:file_cache_path]}/bamboo-#{node['qubit_bamboo']['version']}/bamboo-#{node['qubit_bamboo']['version']} #{node['qubit_bamboo']['home']}/bamboo"
end
file "#{node['qubit_bamboo']['home']}/bamboo" do
  mode 0755
end
directory "#{node['qubit_bamboo']['home']}/webapp" do
  recursive true
end

bash 'copy_bamboo_webapp' do
  cwd ::File.join(Chef::Config[:file_cache_path], "bamboo-#{node['qubit_bamboo']['version']}")
  code <<-EOF
  cp -rp webapp/dist #{node['qubit_bamboo']['home']}/webapp/dist
  cp -rp webapp/fonts #{node['qubit_bamboo']['home']}/webapp/fonts
  cp webapp/index.html #{node['qubit_bamboo']['home']}/webapp/index.html
  EOF
end

template '/etc/init/bamboo-server.conf' do
  source 'bamboo-server.conf.erb'
end
