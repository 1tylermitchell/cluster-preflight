require 'spec_helper'

# Disabling as package name is too specific to use the package function
#describe package('hadoop_2_2_0_0_2041') do
#  it { should be_installed }
#end

describe `rpm -qa hadoop* | wc -l`.to_i do
  it { should be > 0 }
end

describe service('hadoop') do
  it { should be_running   }
end

