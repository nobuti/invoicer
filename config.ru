require 'rubygems'
require 'bundler'

Bundler.require

require "./app"

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/js'
  environment.append_path 'assets/css'
  environment.append_path 'assets/images'
  run environment
end

map '/' do
  run App
end