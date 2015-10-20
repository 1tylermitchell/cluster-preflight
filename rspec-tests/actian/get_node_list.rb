clusterreport,nodesreport = `sudo su hdfs -c 'hdfs dfsadmin -report'`.split("\n\n-------------------------------------------------\n")
nodesreplist=nodesreport.strip.split("\n")

livenodes = nodesreplist.grep(/Live/)[0].split(" ")[2].delete("():")
nodenamelist = nodesreplist.grep(/Name/)
nodenamelist = nodenamelist.map! { |n| n.split(":")[0] == "Name" ? n.split(":")[1].strip : n }.sort
puts nodenamelist.to_s

#for n in nodenamelist do
#  puts n
#end

