#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_src = "ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p195.tar.bz2"

case node["platform"]
when "centos"
  %w[gcc gcc-c++ make autoconf openssl-devel zlib-devel readline-devel].each do |pkg|
    package pkg do
      action :install
    end
  end
else
  raise "Platform #{node["platform"]} not supported"
end

bash "ruby" do
  cwd "/usr/local/src"
  only_if { RUBY_VERSION < "2.0.0" }
  code <<-CODE
    wget #{ruby_src}
    tar xjf #{File.basename(ruby_src)}
    cd #{File.basename(ruby_src, ".tar.bz2")}
    ./configure
    make
    make install
  CODE
end

gem_package "bundler" do
  action :install
end
