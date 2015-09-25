# healthcheck.py
Cluster and Vector on Hadoop SQL database health checking script

Healthcheck.py reviews the state of the cluster before running an Actian Vector on Hadoop install.  Future versions will also do post-install checks and provide optimization tips as well.

The script is also designed using classes and methods that you can incorporate into a custom Python application.  Running the script as stand alone will work as well.

The other files are for dependencies of the Python script or for reference.  The main dependency at this time is access to the Hadoop "hdfs" command.
