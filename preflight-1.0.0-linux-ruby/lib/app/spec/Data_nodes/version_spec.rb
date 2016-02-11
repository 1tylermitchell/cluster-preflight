require 'spec_helper'

# $ hdfs version
# Hadoop 2.6.0.2.2.6.0-2800
# => 2.6

describe `hdfs version | grep Hadoop | cut -d " " -f 2 | cut -d "-" -f 1 | cut -d "." -f 1-2`.to_f do
	it { should be >= 2.6 }
end
