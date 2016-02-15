require 'spec_helper'

describe "Memory/Core should be >= 8GB" do
	it {
		mem_gb = host_inventory['memory']['total'].delete('kB').to_f/1000000
		corecount = `nproc`.to_f
		mempercore = mem_gb/corecount	
		expect(mempercore).to be >= 8
	}
end

