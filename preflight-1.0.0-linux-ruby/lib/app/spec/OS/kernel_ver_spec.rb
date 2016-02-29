require 'spec_helper'

# uname -r
# 2.6.32-504.12.2.el6.x86_64

describe "Check Kernel versions 2.6+" do
	it {
		versions = `uname -r`.split(".")[0..1].join(".").to_f
		expect(versions).to be >= 2.6
	}
end

describe "Check Kernel versions 3.1+" do
	it {
		versions = `uname -r`.split(".")[0..1].join(".").to_f
		expect(versions).to be >= 3.1
	}
end

describe "Check Kernel versions 3.12+ (AWS)" do
	it {
		versions = `uname -r`.split(".")[0..1].join(".").to_f
		expect(versions).to be >= 3.12
	}
end
