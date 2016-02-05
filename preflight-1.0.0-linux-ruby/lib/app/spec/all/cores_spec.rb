require 'spec_helper'

#I hate calling out directly from Ruby like this
## but the function: "command('nproc')" was returning strings I couldn't cast

describe `nproc`.to_i do
	it { should >= 12 }
end

