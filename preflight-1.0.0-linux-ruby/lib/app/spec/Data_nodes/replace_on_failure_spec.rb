require 'spec_helper'
require 'nokogiri'

describe "Replace datanode on failure, best effort" do
        describe file('/etc/hadoop/conf/hdfs-site.xml') do
                it {should contain /dfs.client.block.write.replace-datanode-on-failure/}
                it do
                        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
                        d=doc.xpath("//property[name='dfs.client.block.write.replace-datanode-on-failure']/value").text
                        expect(d).to eq('true')
                end
        end
end
