require 'spec_helper'
#require 'nokogiri'

describe "hdfs-site check for short circuit local reads" do
        describe command('hdfs getconf -confkey dfs.client.read.shortcircuit') do
                its(:stdout) { should match /true/ }
        end
        #describe file('/etc/hadoop/conf/hdfs-site.xml') do
        #        it {should contain /dfs.client.read.shortcircuit/}
        #        it do
        #                doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
        #                d=doc.xpath("//property[name='dfs.client.read.shortcircuit']/value").text
        #                expect(d).to eq('true')
        #        end
        #end
end
