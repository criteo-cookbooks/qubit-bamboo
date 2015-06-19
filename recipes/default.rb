#
# Cookbook Name:: qubit-bamboo
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

include_recipe 'qubit-bamboo::install_from_source'

include_recipe 'qubit-bamboo::config'
