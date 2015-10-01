#!/usr/bin/python

# Copyright 2015 Actian Corporation
 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
 
#      http://www.apache.org/licenses/LICENSE-2.0
 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

class Cluster():
    """Functions for (mostly) pre-install checks of Hadoop/HDFS"""
    
    def capacity(self):
        """
        Settings related to recommended and current capacity needed for cluster.
        Not currently used.
        
        Returns recommended settings dictionary.
        """
        recommended = {
          "Master Min Cores":6,
            "Master Min RAM GB":96,
          "Slave Min Cores":12,
            "Slave Min RAM GB":128,
            "Slave Min Num Disks":12,
            "Slave Min Disk GB":1000
        }
        return recommended

    def hdfsreport(self,hdfs_bin_location='/usr/bin/hdfs'):
        """Return results of the HDFS Cluster Report

        Popen call to dfsadmin utility will attempt to be run as 
        root or HDFS superuser

        Returns:
            node_count      int             number of nodes reported in cluster
            cluster_stats   dict            key/value pairs of disk usage
            node_stats      list of dicts   key/value pairs of disk usage by node

        Options:
            hdfs_bin_location   string      pointing to full hdfs command path and file

        Usage:    hdfsreport(None)[1]['Present Capacity']
                   '11048274690048 (10.05 TB)'
                   hdfsreport(None)[1]['DFS Used%']
                   '33.81%'
        >>> cl=Cluster()
        >>> rep=cl.hdfsreport()
        - Running HDFS admin report...
        """

        from subprocess import Popen, PIPE, call
        from os.path import exists

        # The three variables that will be returned:
        rep_nodecount = 0
        cluster_arr = {}
        nodes_list = []

        # Does the HDFS command exist?
        if exists(hdfs_bin_location):
            print "- Running HDFS admin report..."
            #print '/usr/bin/hdfs command found'

            # Grab the admin output report
            # Full raw output example in dfadmin-report.txt

            # Must be root and elevate to hdfs superuser
            cmdreport = Popen(['su hdfs -c ' + hdfs_bin_location +  '" dfsadmin -report"'], stdout=PIPE, shell=True).communicate()[0].strip()

            # The report data is very ugly, but parsing can be done on a few simple strings
            rep_clustersummary,rep_nodedetails = cmdreport.split('-------------------------------------------------')
            rep_nodecount,rep_nodelist = rep_nodedetails.split('\n\n')[0].replace('\nLive datanodes (','').replace('):',''),\
                                         rep_nodedetails.split('\n')[3:]
            cluster_stats = rep_clustersummary.strip().split("\n")
            cluster_arr = {"Nodes":rep_nodecount}

            # High level stats for overall cluster:
            for stat in cluster_stats:
                repkey,repval = stat.split(': ')
                cluster_arr[repkey]=repval

            # Temp variable for collecting key/values then added to each node in list
            node_keyval_dict = {}
            host_list = []

            # Stats for each node, actually for each key/val pair but result is summarised by node
            for node in rep_nodelist:
                # Second len check is for some items that have no values, which we don't want
                if (len(node) > 0 and len(node[node.find(":")+1:]) > 0):
                    repkey,repval = node.split(': ')
                    if (repkey == "Name"):
                        host_list.append(repval.split(":")[0])
                        # Then it's a new node def starting
                        # Skip the first time the dict comes through empty
                        if (len(node_keyval_dict) > 0):
                            nodes_list.append(node_keyval_dict)
                        node_keyval_dict = {}
                    node_keyval_dict[repkey] = repval
        else:
            print "/usr/bin/hdfs command not found"

        return rep_nodecount,cluster_arr, nodes_list, host_list

    def pingtest(self,host_list):
            """
                hdfsreport.host_list
                
                Returns node dictionary with ping boolean
                                
            """
            import commands # yes, deprecated in future but easier than subprocess.Popen
            ping_status = {}
            for host in host_list:
                status, output = commands.getstatusoutput("ping -c 1 %s" % (host))
                if status == 0:
                    ping_status[host] = True
                else: ping_status[host] = False
            return ping_status

    def pinglatency(self,host_list):
            """
                hdfsreport.host_list
                
                Returns node dictionary with average latency timing over 5 pings

                PING localhost (127.0.0.1) 56(84) bytes of data.
                64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.029 ms
                64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.020 ms
                64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.021 ms
                64 bytes from localhost (127.0.0.1): icmp_seq=4 ttl=64 time=0.016 ms
                64 bytes from localhost (127.0.0.1): icmp_seq=5 ttl=64 time=0.019 ms
                --- 172.16.68.4 ping statistics ---
                8 packets transmitted, 8 received, 0% packet loss, time 1411ms
                rtt min/avg/max/mdev = 0.045/0.050/0.059/0.005 ms
            """

            import commands # yes, deprecated in future but easier than subprocess.Popen
            ping_status = {}
            num_pings = 5
            for host in host_list:
                status, output = commands.getstatusoutput("ping -c %s -i 0.2 %s" % (num_pings, host))
                if (status == 0):
                        # output[-1]:
                        # rtt min/avg/max/mdev = 0.045/0.050/0.059/0.005 ms
                        ping_avg = output.split("\n")[-1].split("/")[5]
                        ping_status[host] = ping_avg
            return ping_status

    def hdfstopology(self,hdfs_bin_location='/usr/bin/hdfs'):
        """
        Currently barely useful, not used for health check but is another
        simple way to get a dictionary of hostname:ip.
        
        Full raw output from dfsadmin command:
        $ hdfs dfsadmin -printTopology
                Rack: /default-rack
                   172.16.68.2:50010 (padb-cluster2)
                   172.16.68.3:50010 (padb-cluster3)
                   172.16.68.4:50010 (padb-cluster4)
                   172.16.68.5:50010 (padb-cluster5)
                   172.16.68.6:50010 (padb-cluster6)
                   172.16.68.7:50010 (padb-cluster7)
                
        Returns list of Racks, with dictionaries of {hostname: ip}
        """
        from subprocess import Popen, PIPE, call
        
        cmdreport = Popen(['su hdfs -c ' + hdfs_bin_location +  '" dfsadmin -printTopology"'], stdout=PIPE, shell=True).communicate()[0].strip()
        rack = cmdreport.split("\n")[0].split(":")[1].strip()
        host_list = cmdreport.split("\n")[1:]
        
        return rack, host_list

    def netcheck(self,host_list):
        """
        Check the network interfaces and their speeds for each node
        
        :param host: host name or IP address as string 
        :return: dictionary of interfaces and link speeds - e.g.:
                {'172.16.68.6': {'eth2': '1000', 'eth0': '10000'}}
        """
        from subprocess import Popen, PIPE, call
        
        
        iface_report = {}
        for host in host_list:
            cmdreport = Popen('ssh -q {0} "ifconfig | grep HWaddr | awk \'{{print $1}}\'"'.format(host), stdout=PIPE, shell=True).communicate()[0].split("\n")
            iface_report[host] = {}
            for nic in cmdreport:
                iface = nic.strip().split(" ")[0]
                if iface:
                    if iface[0:3] == 'eth':
                        ifreport = Popen('ssh -q {0} "cat /sys/class/net/{1}/speed"'.format(host,iface), stdout=PIPE, shell=True).communicate()[0].strip()
                        if str(ifreport) != "": 
                            iface_report[host][iface]=str(ifreport)
        return iface_report

    def diskcheck(self,host_list):
        """
        Each node has a default hadoop script that checks health of all disks
        sh /etc/hadoop/conf/health_check
        
        Output is like:
        ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
         or
        OK: disks ok,
        
        :param host: host name or IP address as string 

        """
        from subprocess import Popen, PIPE, call
        disk_report = {}
        for host in host_list:
            cmdreport = Popen('ssh -q {0} "sh /etc/hadoop/conf/health_check"'.format(host), stdout=PIPE, shell=True).communicate()[0]
            disk_report[host] = cmdreport
        return disk_report
    
class Report:
    """Use reportlab (https://bitbucket.org/rptlab/reportlab) or similar to push all these outputs into PDF"""
    
        
# Other potential classes stubbed in...
    #class VectorH():
    #class RunAll():
    #class PAT():
    #class MQI():

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def runtest():
    import doctest
    doctest.testmod()

def set_status(var1,var2):
    # var1 = smaller number
    # var2 = larger number
    if (var1 > var2):
        status = bcolors.FAIL
    elif (var1 == var2):
        status = bcolors.WARNING
    else:
        status = bcolors.OKGREEN
    return status

if __name__ == "__main__":

    # Import table printing tools
    from pprinttable import pprinttable as pp
    from collections import namedtuple
    
    # This option uses doctest to check the code used in this script
    q_test = raw_input('Test script code (y/n) [n]: ')
    if (q_test == 'y'):
        runtest()

    # Target number of nodes is optional for reporting purposes only
    q_nodes_target = raw_input('Enter desired/expected number of nodes [4]: ')
    if (len(q_nodes_target)>0):
      a_nodes_target = int(q_nodes_target)
    else: a_nodes_target = 4

    # Target data volume optional for reporting purposes only. 
    # This will be compared to 75% of cluster capacity in reports.
    q_data_target = raw_input('Enter data target volume (TB) [1]: ')
    if (len(q_data_target)>0):
      a_data_target = int(q_data_target)
    else: a_data_target = 1

    # Start the HDFS report for cluster
    cluster = Cluster()
    rep=cluster.hdfsreport()
    
    # Messy but grabbing basic output in just a few lines
    nodes,cap_str=rep[0], rep[1]['Configured Capacity'].split("(")[1].split(")")[0]
    cap_nodes,cap_flt,cap_units=float(cap_str.split(" ")[0])/int(nodes), float(cap_str.split(" ")[0]), cap_str.split(" ")[1]

    # Using set_status allows the output to be coloured if outside target ranges
    data_status = set_status(a_data_target, (0.75*cap_flt))
    nodes_status = set_status(a_nodes_target, nodes)
    cap_node_status = set_status((float(a_data_target)/a_nodes_target),cap_nodes)

    # Prep for printing out a table of results in terminal
    Row = namedtuple('Row',['Type','Nodes','Total_Capacity','Cap_per_Node'])
    founddata=Row("Found",str(nodes),cap_str,str(round(cap_nodes,3)) + cap_units)
    targetdata=Row("Target",str(a_nodes_target),str(float(a_data_target))+" TB",str(round(float(a_data_target)/float(a_nodes_target),3)) + cap_units)
    pp([founddata,targetdata])
        
    q_ping = raw_input('Start ping test (y/n)? [y]: ')
    if (q_ping != 'n'):
        print "- Running ping test on nodes"
        ping_results=cluster.pingtest(rep[3])
        Row = namedtuple('Row',['Host','Live'])
        for p in ping_results:
            print ("{0}\t{1}").format(p,ping_results[p])

    q_pinglat = raw_input('Test ping latency (y/n)? [y]: ')
    if (q_pinglat != 'n'):
        print "- Running ping latency test on nodes"
        ping_results=cluster.pinglatency(rep[3])
        Row = namedtuple('Row',['Host','Latency'])
        for p in ping_results:
            print ("{0}\t{1}").format(p,ping_results[p])
            
    q_diskcheck = raw_input('Disk check all nodes (y/n)? [y]: ')
    if (q_diskcheck != 'n'):
        print "- Running disk check on all nodes"
        disk_results=cluster.diskcheck(rep[3])
        Row = namedtuple('Row',['Host','DiskReport'])
        print_rows = []
        for host in disk_results:
            row_to_print = Row(host, disk_results[host].strip())
            print_rows.append(row_to_print)
        pp(print_rows)    

    q_niccheck = raw_input('Check network interface speeds (y/n)? [y]: ')
    if (q_niccheck != 'n'):
        print "- Running NIC check on all nodes"
        nic_results=cluster.netcheck(rep[3])
        Row = namedtuple('Row',['Host','Interface','Speed'])
        print_rows = []
        for host in nic_results:
            for nic in nic_results[host]:
                print "in nic in hosts: " + host,nic
                row_to_print = Row(host,nic,nic_results[host][nic])
                print_rows.append(row_to_print)
        pp(print_rows)