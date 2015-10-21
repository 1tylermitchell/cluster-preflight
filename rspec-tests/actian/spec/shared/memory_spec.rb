require 'spec_helper'

  puts "ServerSpec tests on #{ENV['TARGET_HOST']}"

#shared_examples 'datanode::memory' do
	describe "Node Memory Availability" do
		describe host_inventory['memory']['total'].delete('kB').to_i do
			it { should >=  0 }
		end
	end
#end
