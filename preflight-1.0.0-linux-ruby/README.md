This is a Ruby-based serverspec example - deployed as a self contained Traveling Ruby app for Linux, developed from Serverspec-example (Vincent Bernat).  See my blog post explaining this in a bit more detail: http://www.makedatauseful.com/serverspec-checks-settings-on-a-hadoop-cluster/ - it queries YARN to get a list of the Hadoop nodes in a cluster and runs a series of checks on each one, producing a report that can be viewed through a web browser.

## Sample usage ##
A couple simple startup scripts are included.  Main apps are located in lib/app folder if you want to dig into them further.

**Launch:**

  * ./healthcheck.sh
  
**View reports:**

  * ./reportserv.sh
  * Then view report server at http://localhost:5000/viewer
  * Currently there are issues with the built-in Ruby web server used here so I have used a Python web server for testing so far: ./reportserv_py.sh
