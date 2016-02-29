This application is designed to check the settings of a modern, Linux-based, Hadoop cluster and also for [Actian's SQL on Hadoop platform](http://www.actian.com/products/analytics-platform/vortex-sql-hadoop-analytics/).  Then it produces a report that can be viewed in a web browser showing the status of each test.

No installation is required, only download and unzip.

This is a Ruby-based serverspec example - deployed as a Travelling Ruby app, developed from [ Serverspec-example by Vincent Bernat](https://github.com/vincentbernat/serverspec-example).  See [my blog post](http://www.makedatauseful.com/serverspec-checks-settings-on-a-hadoop-cluster/) explaining this in a bit more detail - it queries YARN to get a list of the Hadoop nodes in a cluster and runs a series of checks on each one, producing a report that can be viewed through a web browser.

----------
# Installation #
Self contained Ruby app with all libs and binaries required.

To install, grab the master zip file.  On some command line systems you will need to use to curl with the -L option:

 * curl -Lo master.zip https://github.com/1tylermitchell/preflight/archive/master.zip
  
## Sample usage ##
A couple simple startup scripts are included.  Main apps are located in lib/app folder if you want to dig into them further.

**Launch:**

  * `./preflight.sh`
  
**View reports:**

  * `./reportserv.sh`
  * Then view report server at http://localhost:5000/viewer/#/url/http://localhost:5000/reports/report.json 

------------
# Configuration #

All the settings are in text files so they can be easily changed without having to rebuild anything.  If you make a change, just re-run the `preflight.sh` script and refresh the web brower.

## Hosts ##
By default, the application will query YARN to get a list of hodes in the cluster.  It uses the command: `yarn nodes -list`.  In some cases you may want to use a different method for building the list of nodes or build a list manually.  To have a manual list of nodes edit or create the file called `hosts.txt` in the root folder of the application, listing a single IP or hostname on each line.  If this file exists, then the application will use it.  If it is not needed then delete or move the file.

## Tests / Specs ##
All the spec files used for testing are in the main application subfolder `lib/app/`.  Some start-up settings are stored in `lib/app/Rakefile`.  The tests themselves are in `lib/app/spec/` and stored according to type of test.  If you create a new folder here be sure to add it to the `Rakefile` so it knows to look in that folder for more tests, i.e.:  `roles << "Disk"` adds the folder called `Disk` to the list of folders to use for tests.

## Web Output ##
The results of tests are stored in `lib/app/reports/report.json`.  They are read directly by the AngularJS app that is in the folder `lib/app/viewer` - you can tweak files in there to change the formatting, etc.

--------------
# Features #
Note that some checks are OS dependant, so some will fail on different versions of distributions of Linux.  

This testing system does only a pass/fail (not a "warning") style response, some tests are run a couple times to check at varying thresholds.  For example, memory will be checked at a lower level and a higher level - if they both fail you are in trouble.  But if only one fails then you can consider that the system has minimum amounts but not recommend amounts of memory.

Here is a list of the checks that are done in the app:

## Data Nodes ##
 * Hadoop RPM is installed
 * Hadoop as a service is running
 * Replication is not zero (dfs.replication >= 1)
 * Client will replace nodes if failing (dfs.client.block.write.replace-datanode-on-failure = true)
 * Bypass datanode with short circuit read (dfs.client.read.shortcircuit = true)
 * Short circuit stream cache is not small (dfs.client.read.shortcircuit.streams.cache.size >= 4096)
 * Transfer threads is not small (dfs.datanode.max.transfer.threads >= 4096)
 * HDFS version is recent (hdfs version >= 2.6)

## Disk ##
 * Copy to/from HDFS is fast enough (100M/sec+)
 * At least 12 disks being used

## Hadoop Ports ##
 * Web UI port is open for the datanode (50075)
 * Data transfer port is open (50010)
 * Web UI port is open for the namenode (50070)

## Memory ##
 * Node memory is at least 125GB
 * Node memory is at least 256GB
 * Per core memory is at least 8GB

## Network ##
 * Fastest network interface is at least 1GB
 * Fastest network interface is at least 10GB
 
## Operating System ##
 * Kerberos client is installed (krb5-workstation package)
 * Kernel version thresholds are one of: 2.6+, 3.1+, 3.12+ (3.12+ is recommended for AWS usage specifically)
 * Network time daemon is running (ntpd)
 * Transparent Huge Pages (THP) is disabled
 * Number of files able to be opened is at least 10,000 (ulimit hard and soft)

## VectorH ##
 * VectorVH is install in standard folder
 * Configuration file exists (config.data should only exist on master node)
 * Namenode usage optimized for open files, blocks per file, number of disks
 * Version is at least 4.2.2 patch 22108

# Next Steps and Improvements #
 * Simplify HDFS throughout checks 
 * Include additional VectorH performance checks
 * Allow master node analysis to be done separately from data nodes, requires manual list defining which are which
 * Improve layout of report - transform JSON with Angular
 * Produce PDF or text output report instead of JSON
