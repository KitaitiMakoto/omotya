require 'spec_helper'

describe file('/opt/nginx/sbin/nginx') do
  it { should be_executable }
end

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

describe file('/opt/nginx/conf/nginx.conf') do
  it { should be_file }
  it { should contain "server_name omotya" }
end
