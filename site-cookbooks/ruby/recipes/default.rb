#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_src = "ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.bz2"
ruby_bin = Pathname("/usr/local/bin/ruby")

%w[gcc gcc-c++ make autoconf openssl-devel zlib-devel readline-devel].each do |pkg|
  package pkg do
    action :install
  end
end

bash "install ruby" do
  cwd "/usr/local/src"
  not_if { ruby_bin.executable? and `#{ruby_bin} -v` =~ /\Aruby 2\.0/ }
  code <<-CODE
    wget #{ruby_src}
    tar xjf #{File.basename(ruby_src)}
    cd #{File.basename(ruby_src, ".tar.bz2")}
    ./configure --prefix=#{node["ruby"]["prefix"]}
    make
    make install
  CODE
end

gem_package "bundler" do
  gem_binary node["gem"]["binary"]
  action :install
end
