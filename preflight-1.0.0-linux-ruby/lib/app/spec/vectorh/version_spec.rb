require 'spec_helper'

# $II_SYSTEM/ingres/version.dat
# [actian@rushcluster-worker1 ingres]$ cat version.dat
# ## action      performed        status  patch seq  version
# ##
# install   03-Feb-2016 12:08:36  valid   22108   1  VH 4.2.2 (a64.lnx/221)
# install   16-Dec-2015 17:39:57  valid   22102   1  VH 4.2.2 (a64.lnx/221)
# install   02-Apr-2015 09:46:47  valid   15801   1  VH 4.1.1 (a64.lnx/158)
#
#
describe "Check VectorH versions" do
	it {
		versions = []
		verlines=`cat $II_SYSTEM/ingres/version.dat|grep install`.split("\n")

		verlines.each{|d| 
			versions.push(d.split(" ")[4])
		}
		expect(versions.max.to_i).to be >= 22108
	}
end
