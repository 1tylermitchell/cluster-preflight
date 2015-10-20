require 'spec_helper'

#shared_examples 'datanode::memory' do
	describe "Node Memory Availability" do
		describe host_inventory['memory']['total'].delete('kB').to_i do
			it { should >= 1280000000 }
		end
	end
#end
