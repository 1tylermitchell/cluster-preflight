require 'spec_helper'

describe "Node Memory Availability" do

	describe host_inventory['memory']['total'].delete('kB').to_i do
		it { should > 0 }
	end
end
