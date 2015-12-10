require 'spec_helper'

#describe command('grep dfs.replication /etc/hadoop/conf/hdfs-site.xml -A1 | tail -n1 | sed "s/\(^[ \t]*\|<\|>\)/\t/g" | cut -f4'.to_i) do
#	it { should be > 0 }
#end

describe "hdfs-site check for dfs.replication" do
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
