  * preflight-1.0.0-linux-ruby folder: this is a Ruby-based serverspec example - deployed as a Travelling Ruby app, developed from [ Serverspec-example by Vincent Bernat](https://github.com/vincentbernat/serverspec-example).  See [my blog post](http://www.makedatauseful.com/serverspec-checks-settings-on-a-hadoop-cluster/) explaining this in a bit more detail - it queries YARN to get a list of the Hadoop nodes in a cluster and runs a series of checks on each one, producing a report that can be viewed through a web browser.
  
----------
# preflight-1.0.0-linux-ruby
Self contained Ruby app with all libs and binaries required.

To install, grab the master zip file.  On some command line systems you will need to use to curl with the -L option:

 * curl -Lo master.zip https://github.com/1tylermitchell/preflight/archive/master.zip
  
## Sample usage ##
A couple simple startup scripts are included.  Main apps are located in lib/app folder if you want to dig into them further.

**Launch:**

  * ./preflight.sh
  
**View reports:**

  * ./reportserv.sh
  * Then view report server at http://localhost:5000/viewer/#/url/http://localhost:5000/reports/report.json 
  * Currently there are issues with the built-in Ruby web server used here so I have used a Python web server for testing so far: ./reportserv_py.sh

