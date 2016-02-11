require 'spec_helper'
require 'nokogiri'

describe "hdfs-site check for short circuit local reads" do
        describe file('/etc/hadoop/conf/hdfs-site.xml') do
                it {should contain /dfs.client.read.shortcircuit/}
                it do
                        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
                        d=doc.xpath("//property[name='dfs.client.read.shortcircuit']/value").text
                        expect(d).to eq('true')
                end
        end
end
