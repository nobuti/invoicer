ENV["RACK_ENV"] ||= "test"

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '../app.rb')

# setup test environment
set :run, false
set :raise_errors, true
set :logging, false

def app
  App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end