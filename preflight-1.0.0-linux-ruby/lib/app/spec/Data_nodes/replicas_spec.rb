require 'spec_helper'

describe "hdfs config for dfs.replication" do
#        describe file('/etc/hadoop/conf/hdfs-site.xml') do
#                it do
#                        doc = Nokogiri::XML(File.read("/etc/hadoop/conf/hdfs-site.xml"))
#                        d=doc.xpath("//property[name='dfs.replication']/value").text.to_i
#                        expect(d).to be >= 1
#                end
#        end
        describe command('hdfs getconf -confkey dfs.replication') do
                its(:stdout) { expect(subject.stdout.to_i).to be >= 1 }
        end
end
