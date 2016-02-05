require 'spec_helper'

describe `lsblk -a | grep disk | wc -l`.to_i do
	it { should be >=  12 }
end
