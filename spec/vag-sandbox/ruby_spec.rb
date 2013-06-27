require 'spec_helper'

bin_dir = '/usr/local/bin'

describe command("#{bin_dir}/ruby -v") do
  it {should return_stdout /ruby 2\.0\.\dp/}
end

describe command("#{bin_dir}/bundle -v") do
  it {should return_stdout /\ABundler version/}
end
