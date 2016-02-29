require 'spec_helper'
#require 'nokogiri'

describe "Replace datanode on failure, best effort" do
	describe command('hdfs getconf -confkey dfs.client.block.write.replace-datanode-on-failure') do
		its(:stdout) { should match /true/ }
	end
#                it do
#                        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
#                        d=doc.xpath("//property[name='dfs.client.block.write.replace-datanode-on-failure']/value").text
#                        expect(d).to eq('true')
#                end
#        end
end
