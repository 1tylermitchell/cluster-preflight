require 'spec_helper'

describe "MB/S copy to HDFS" do
	it {
		mkfile = `fallocate -l 100M /tmp/100M.img`
		setOutTime = `/usr/bin/time -f "%e" -o /tmp/t1 hdfs dfs -copyFromLocal -f /tmp/100M.img /tmp;`
		cpOutTime=`cat /tmp/t1`
                rmfile = `rm /tmp/100M.img; rm /tmp/t1`
		mbPerSecondOut=100/cpOutTime.to_f
		expect(mbPerSecondOut).to be >= 100
	}
end

describe "MB/S copy from HDFS" do
        it {
                rmfile = `rm -f /tmp/100M.img`
                setInTime = `/usr/bin/time -f "%e" -o /tmp/t2 hdfs dfs -copyToLocal /tmp/100M.img /tmp`
                rmfile = `hdfs dfs -rm -skipTrash /tmp/100M.img`
                cpInTime=`cat /tmp/t2`
                rmfile = `rm /tmp/100M.img; rm /tmp/t2`
                mbPerSecondIn=100/cpInTime.to_f
                expect(mbPerSecondIn).to be >= 100 
        }
end
