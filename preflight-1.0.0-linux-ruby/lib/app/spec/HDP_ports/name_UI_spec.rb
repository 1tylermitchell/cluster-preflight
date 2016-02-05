require 'spec_helper'

describe port(50070) do
  it { should be_listening }
end

