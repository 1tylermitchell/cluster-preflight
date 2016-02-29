require 'spec_helper'
#
# Adding some settings in vectorwise.conf [cbm] section
# can make less work for the namenode if that is an issue
# in a very busy cluster.  None of these settings are on by
# default.
#
# max_open_files=16000
# multithreaded_hdfs_num_disks=2
# hdfs_blocks_per_file=4096
#  
#  This way we force our code to think there are two disks, so 4 threads total instead of 24
#  The blocks per file setting makes bigger files, so less pressure on the namenode
#

describe "Settings for optimizing namenode usage" do
	describe file('/opt/Actian/VectorVH/ingres/data/vectorwise/vectorwise.conf') do
		it { should contain('max_open_files=16000') }
	        it { should contain('multithreaded_hdfs_num_disks=2') }
	        it { should contain('hdfs_blocks_per_file=4096') }
	end
end
