require 'spec_helper'

describe interface('eth0') do
  its(:speed) { should be >= 1000 }
end
