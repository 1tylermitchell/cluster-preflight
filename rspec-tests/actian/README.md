ServerSpec Node Health Check
==============================

This is a test environment for using ServerSpec processes to check on the 
health of a cluster before and after installation of an Actian Vector on Hadoop 
installation.

Dependencies
--------------
 * Ruby
 * gems: serverspec
 * sudo access or HDFS admin privileges
 * access to HDSF admin reporting tool on a cluster

Installing
-------------

Running 
--------
 - change into this folder
 - execute the Ruby ``rake`` command
 - optionally: execute ``run_parallel.sh`` to improve performance but produce less readable output
 - results are stored in /tmp/[hostname].json files and output to screen
