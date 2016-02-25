#
# Cookbook Name:: qubit-bamboo
# Recipe:: default
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

file node['qubit_bamboo']['flags']['config'] do
  content Chef::JSONCompat.to_json_pretty(node['qubit_bamboo']['config'])
  notifies :restart, 'poise_service[bamboo]'
end

# Wrapper is not used anymore
file ::File.join(node['qubit_bamboo']['home'], 'bamboo-wrapper.sh') do
  action :delete
end

# disable the old bamboo-server service
service 'bamboo-server' do
  provider Chef::Provider::Service::Upstart
  action [:disable, :stop]
  only_if { node['platform_version'].to_i < 7 && ::File.exist?('/etc/init/bamboo-server.conf') }
end

file '/etc/init/bamboo-server.conf' do
  action :delete
end

bin = ::File.join(node['qubit_bamboo']['home'], 'bamboo')
flags = node['qubit_bamboo']['flags'].sort.map { |k, v| " -#{k}=#{v}" }.join ' '
syslog = node['qubit_bamboo']['syslog'] ? '2>&1 | logger -p user.info -t bamboo' : ''

node.default['qubit_bamboo']['poise_service']['options'] = {
  upstart: {
    command: %("#{bin} #{flags} #{syslog}"),
  },
  systemd: {
    command: "#{bin} #{flags}",
  },
}

poise_service 'bamboo' do
  node['qubit_bamboo']['poise_service']['options'].each do |k, v|
    options k, v
  end
end
