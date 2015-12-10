require 'spec_helper'
require 'nokogiri' # For XML parsing of config files
#require 'pathname' # not sure if needed now

describe "Processor count" do
  # I hate calling out directly from Ruby like this
  # but the function: "command('nproc')" was returning strings I couldn't cast

  describe `nproc`.to_i do
    it { should >= 12 }
  end
end

describe "Ulimits" do
  describe command('ulimit') do
    its(:value) { should be >= 65000 }
  end
end

describe "Hadoop packages exist" do
  # Disabling package function method as name is too version specific
  # Need a way to generalise the check for package on non Centos

  #describe package('hadoop_2_2_0_0_2041') do
  #  it { should be_installed }
  #end
  
  describe `rpm -qa hadoop* | wc -l`.to_i do
    it { should be > 0 }
  end
end

describe "Hadoop service running" do
  # Check that this works on non Centos environments
  describe service('hadoop') do
    it { should be_running   }
  end
end

describe "HDFS Configuration" do
  # Checking XML file via bash, replaced by XML nokogiri lib further down
  #describe command('grep dfs.replication /etc/hadoop/conf/hdfs-site.xml -A1 | tail -n1 | sed "s/\(^[ \t]*\|<\|>\)/\t/g" | cut -f4'.to_i) do
  #	it { should be > 0 }
  #end
  
  describe "dfs.replication" do
    describe file('/etc/hadoop/conf/hdfs-site.xml') do
      #it {should be_file}
      it {should contain /dfs.replication/}
      it do
        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
        d=doc.xpath("//property[name='dfs.replication']/value").text.to_i
        expect(d).to be >= 1
      end
    end
  end

  # Checking XML file via bash, replaced by XML nokogiri lib further down
  # describe `grep dfs.client.read.shortcircuit.streams.cache.size /etc/hadoop/conf/hdfs-site.xml -A1 | tail -n1 | sed "s/\(^[ \t]*\|<\|>\)/\t/g" | cut -f4`.to_i do
  #	it { should be >= 4096 }
  #end
  
  describe "streams.cache.size" do
    describe file('/etc/hadoop/conf/hdfs-site.xml') do
      #it {should be_file}
      it {should contain /dfs.client.read.shortcircuit.streams.cache.size/}
      it do
        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
        d=doc.xpath("//property[name='dfs.client.read.shortcircuit.streams.cache.size']/value").text.to_i
        expect(d).to be >= 4096
      end
    end
  end

  describe "max.transfer.threads" do
    describe file('/etc/hadoop/conf/hdfs-site.xml') do
      #it {should be_file}
      it {should contain /dfs.datanode.max.transfer.threads/}
      it do
        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
        d=doc.xpath("//property[name='dfs.datanode.max.transfer.threads']/value").text.to_i
        expect(d).to be >= 4096
      end
    end
  end
end

describe "Disk count" do
  describe `lsblk -a | grep disk | wc -l`.to_i do
    it { should be >=  12 }
  end
end

describe "HDFS Ports" do
  describe "Data UI Port" do
    describe port(50075) do
      it { should be_listening }
    end
  end

  describe "Data Transfer Port" do
    describe port(50010) do
      it { should be_listening }
    end
  end

  describe "Name node UI Port" do
    describe port(50070) do
      it { should be_listening }
    end
  end
end

describe "Node Memory Availability 128/256GB" do
	describe host_inventory['memory']['total'].delete('kB').to_i do
		it { should >=  128000000 }
	end

	describe host_inventory['memory']['total'].delete('kB').to_i do
		it { should >=  256000000 }
	end
end

describe "Network Interfaces" do
  describe interface('eth0') do
    its(:speed) { should be >= 10000 }
  end
  
  describe interface('eth0') do
    its(:speed) { should be >= 1000 }
  end
  
  describe interface('eth1') do
    its(:speed) { should be >= 10000 }
  end
  
  describe interface('eth1') do
    its(:speed) { should be >= 1000 }
  end
end

describe "THP Disabled" do
  describe command('cat /sys/kernel/mm/redhat_transparent_hugepage/enabled') do
    its(:stdout) { should contain('[never]') }
  end
end

