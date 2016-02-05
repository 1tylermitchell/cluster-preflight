require 'spec_helper'

describe interface('eth1') do
  its(:speed) { should be >= 1000 }
end
