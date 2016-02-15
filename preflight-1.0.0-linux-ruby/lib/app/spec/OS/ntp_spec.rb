require 'spec_helper'

describe service('ntpd') do
  it { should be_running   }
end
