require 'spec_helper'

describe "Fastest network interface speed >= 10GB" do
	it {
		linkspeeds = []
		devlines=`ip -o link show`.split("\n")

		devlines[1..devlines.count].each{ |d|
                        devspeed = d.split("\\")[0].split(" ")[-1]
                        if devspeed.valid_float? then linkspeeds.push(devspeed) end
		}
		expect(linkspeeds.max.to_i).to be >= 10000
	}
end
