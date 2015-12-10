require 'spec_helper'
require 'nokogiri'

describe "hdfs-site check for max.transfer.threads" do
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
