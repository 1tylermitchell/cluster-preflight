clusterreport,nodesreport = `sudo su hdfs -c 'hdfs dfsadmin -report'`.split("\n\n-------------------------------------------------\n")
nodesreplist=nodesreport.strip.split("\n")

livenodes = nodesreplist.grep(/Live/)[0].split(" ")[2].delete("():")
nodenamelist = nodesreplist.grep(/Name/)
nodenamelist = nodenamelist.map! { |n| n.split(":")[0] == "Name" ? n.split(":")[1].strip : n }.sort
for n in nodenamelist do
  puts n
end


# Need to dump this output into properties.yaml so the script can use it for the host list cycling
# Update Rakefile to run this prior to execution