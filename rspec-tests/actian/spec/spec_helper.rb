require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))

Dir[base_spec_dir.join('shared/**/*.rb')].sort.each{ |f| require f }

set :backend, :ssh
set :disable_sudo, true

properties = YAML.load_file(base_spec_dir.join('properties.yml'))

options = Net::SSH::Config.for(host)
options[:user] = 'actian'
host = ENV['TARGET_HOST']
host_run_on = options[:host_name] || host


set :host,        options[:host_name] || host
set :ssh_options, options

RSpec.configure do |c|
   c.after(:each) do |example|
      if example.exception
        puts "Failed on #{host_run_on}"
      end
   end
end

set_property properties[host]
