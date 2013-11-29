require 'rubygems'
require 'vcr'
require 'webmock/rspec'

ENV["mode"] = "test"

require_relative '../lib/sbire'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end
