require 'spec_helper'

describe 'Kerberos client' do
	describe package('krb5-workstation') do
	  it { should be_installed }
	end
end
