require 'spec_helper'

describe 'VH Folder' do
        describe file('/opt/Actian/VectorVH/') do
                it {should be_directory}
        end
end

describe 'VH Config.dat' do
	describe file('/opt/Actian/VectorVH/ingres/files/config.dat') do
		it {should be_file}
	end
end
