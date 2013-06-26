#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# For CentOS
service "iptables" do
  action [ :disable, :stop ]
end
