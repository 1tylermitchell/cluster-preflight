# healthcheck.py
Cluster and Vector on Hadoop SQL database health checking script

Healthcheck.py reviews the state of the cluster before running an Actian Vector on Hadoop install.  Future versions will also do post-install checks and provide optimization tips as well.

The script is also designed using classes and methods that you can incorporate into a custom Python application.  Running the script as stand alone will work as well.

The other files are for dependencies of the Python script or for reference.  The main dependency at this time is access to the Hadoop "hdfs" command.

## Sample usage

**Launch:**

``` $ python healthcheck.py```

**Select targets for compare to actual:**
```
 Enter desired/expected number of nodes [4]:
 Enter data target volume (TB) [1]:
```

**Script must run the HDFS admin report step to get list of nodes, etc for remainder of script:**
```
- Running HDFS admin report...
Type   | Nodes | Total_Capacity | Cap_per_Node
-------+-------+----------------+-------------
Found  | 6     | 10.82 TB       | 1.803TB
Target | 4     | 1.0 TB         | 0.25TB
```

**Ping test uses node list and just checks if they respond:**
```
Start ping test (y/n)? [y]:
- Running ping test on nodes
172.16.68.6     True
172.16.68.7     True
172.16.68.4     True
172.16.68.5     True
172.16.68.2     True
172.16.68.3     True
```

**Ping latency uses node list and reports an average response time:**
```
Test ping latency (y/n)? [y]:
- Running ping latency test on nodes
172.16.68.6     0.061
172.16.68.7     0.058
172.16.68.4     0.061
172.16.68.5     0.027
172.16.68.2     0.055
172.16.68.3     0.056
```

**Disk check looks at all the mounted disks on each node and sees if they are accessible.  Ones that are not, are reported as ERROR:**
```
Disk check all nodes (y/n)? [y]:
- Running disk check on all nodes
Host        | DiskReport
------------+------------------------------------------------------------------------------------------------------
172.16.68.6 | ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
172.16.68.7 | OK: disks ok,
172.16.68.4 | ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
172.16.68.5 | ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
172.16.68.2 | ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
172.16.68.3 | ERROR  /mnt/d10(u) /mnt/d11(u) /mnt/d12(u) /mnt/d13(u) /mnt/d14(u) /mnt/d15(u) /mnt/d8(u) /mnt/d9(u),
```

**Network interface check reviews all NICs on each node and reports back they interface and speed:**
```
Check network interface speeds (y/n)? [y]:
- Running NIC check on all nodes
Host        | Interface | Speed
------------+-----------+------
172.16.68.6 | eth2      | 1000
172.16.68.6 | eth0      | 10000
172.16.68.7 | eth3      | -1
172.16.68.7 | eth2      | 1000
172.16.68.7 | eth1      | -1
172.16.68.7 | eth0      | 10000
172.16.68.4 | eth2      | 1000
172.16.68.4 | eth0      | 10000
172.16.68.5 | eth2      | 1000
172.16.68.5 | eth0      | 10000
172.16.68.2 | eth2      | 1000
172.16.68.2 | eth0      | 10000
172.16.68.3 | eth2      | 1000
172.16.68.3 | eth0      | 10000
```
