require 'spec_helper'

describe 'Hard limit for nofiles' do
  subject { command("ulimit -Hn") }
  it 'should be 10k or more' do
    expect(subject.stdout.to_i).to be >= 10000
  end
end

describe 'Soft limit for nofiles' do
  subject { command("ulimit -Sn") }
  it 'should be 10k or more' do
    expect(subject.stdout.to_i).to be >= 10000
  end
end



