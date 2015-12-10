require 'spec_helper'

describe interface('eth0') do
  its(:speed) { should be >= 10000 }
end
