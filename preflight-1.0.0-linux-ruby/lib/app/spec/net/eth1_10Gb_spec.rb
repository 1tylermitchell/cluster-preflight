require 'spec_helper'

describe interface('eth1') do
  its(:speed) { should be >= 10000 }
end
