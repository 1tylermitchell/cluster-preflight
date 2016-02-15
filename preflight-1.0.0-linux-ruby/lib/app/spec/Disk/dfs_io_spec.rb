require 'spec_helper'

describe "MB/S copy to HDFS" do
	it {
		mkfile = `fallocate -l 1G /tmp/1G.img`
		setOutTime = `/usr/bin/time -f "%e" -o /tmp/t1 hdfs dfs -copyFromLocal -f /tmp/1G.img /tmp;`
		cpOutTime=`cat /tmp/t1`
                rmfile = `rm /tmp/1G.img; rm /tmp/t1`
		mbPerSecondOut=1000/cpOutTime.to_f
		expect(mbPerSecondOut).to be >= 100
	}
end

describe "MB/S copy from HDFS" do
        it {
                rmfile = `rm -f /tmp/1G.img`
                setInTime = `/usr/bin/time -f "%e" -o /tmp/t2 hdfs dfs -copyToLocal /tmp/1G.img /tmp`
                rmfile = `hdfs dfs -rm -skipTrash /tmp/1G.img`
                cpInTime=`cat /tmp/t2`
                rmfile = `rm /tmp/1G.img; rm /tmp/t2`
                mbPerSecondIn=1000/cpInTime.to_f
                expect(mbPerSecondIn).to be >= 100 
        }
end
