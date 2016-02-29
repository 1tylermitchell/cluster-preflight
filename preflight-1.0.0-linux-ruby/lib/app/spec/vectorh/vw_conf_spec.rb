require 'spec_helper'

describe 'vectorwise.conf' do
	describe file('/opt/Actian/VectorVH/ingres/data/vectorwise/vectorwise.conf') do
		it {should be_file}
	end
end
