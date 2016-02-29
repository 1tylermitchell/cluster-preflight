require 'spec_helper'
#require 'nokogiri'

#describe `grep dfs.client.read.shortcircuit.streams.cache.size /etc/hadoop/conf/hdfs-site.xml -A1 | tail -n1 | sed "s/\(^[ \t]*\|<\|>\)/\t/g" | cut -f4`.to_i do
#	it { should be >= 4096 }
#end

describe "hdfs-site check for streams.cache.size" do
        describe command('hdfs getconf -confkey dfs.client.read.shortcircuit.streams.cache.size') do
                its(:stdout) { expect(subject.stdout.to_i).to be >= 4096 }
        end
#        describe file('/etc/hadoop/conf/hdfs-site.xml') do
#                #it {should be_file}
#                it {should contain /dfs.client.read.shortcircuit.streams.cache.size/}
#                it do
#                        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
#                        d=doc.xpath("//property[name='dfs.client.read.shortcircuit.streams.cache.size']/value").text.to_i
#                        expect(d).to be >= 4096
#                end
#        end
end
