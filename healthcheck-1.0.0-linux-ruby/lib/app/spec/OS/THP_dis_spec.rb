require 'spec_helper'

describe command('cat /sys/kernel/mm/redhat_transparent_hugepage/enabled') do
	its(:stdout) { should contain('[never]') }
end
