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

bin = ::File.join(node['qubit_bamboo']['home'], 'bamboo')
flags = node['qubit_bamboo']['flags'].sort.map { |k, v| " -#{k}=#{v}" }.join ' '
syslog = node['qubit_bamboo']['syslog'] ? '2>&1 | logger -p user.info -t bamboo' : ''
bamboo_command = "#{bin} #{flags} #{syslog}"

poise_service 'bamboo' do
  command bamboo_command
end
