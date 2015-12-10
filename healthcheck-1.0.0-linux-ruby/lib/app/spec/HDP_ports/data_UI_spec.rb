require 'spec_helper'

describe port(50075) do
  it { should be_listening }
end

