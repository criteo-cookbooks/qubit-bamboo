#
# Cookbook Name:: qubit-bamboo
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

file node['qubit_bamboo']['config_path'] do
  content node['qubit_bamboo']['config'].to_json
end

template ::File.join('/','etc', 'bamboo-server.conf') do
  source 'bamboo-server.conf.erb'
end

