#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

group "nginx" do
  group_name "nginx"
  action     [:create]
end

user "nginx" do
  comment  "nginx"
  group    "nginx"
  home     "/var/run/nginx"
  shell    "/bin/false"
  password nil
  supports :manage_home => true
  action   [:create, :manage]
end

directory node["nginx"]["app_root"] do
  owner  "nginx"
  group  "nginx"
  mode   0755
  action [:create]
  recursive true
end

directory "/var/log/nginx" do
  owner  "nginx"
  group  "nginx"
  mode   0755
  action [:create]
end

%w[gcc gcc-c++ make wget curl-devel openssl-devel zlib-devel].each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "passenger" do
  not_if "#{node["gem"]["binary"]} list --installed passenger"
  gem_binary node["gem"]["binary"]
  action :install
end

bash "install nginx and passenger-module" do
  not_if { `#{node["nginx"]["prefix"]}/sbin/nginx -V 2>&1` =~ /passenger/ }
  code "passenger-install-nginx-module --auto --auto-download --prefix=#{node["nginx"]["prefix"]}"
end

template "init.d/nginx" do
  path "/etc/init.d/nginx"
  source "nginx"
  owner "root"
  group "root"
  mode 0744
end

template "nginx.conf" do
  path "#{node["nginx"]["prefix"]}/conf/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[nginx]'
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end
