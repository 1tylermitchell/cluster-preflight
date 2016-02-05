require 'spec_helper'

describe command('ulimit') do
        its(:value) { should be >= 65000 }
end
