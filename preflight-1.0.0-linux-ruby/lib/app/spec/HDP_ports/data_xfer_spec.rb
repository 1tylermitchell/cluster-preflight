require 'spec_helper'

describe port(50010) do
  it { should be_listening }
end

