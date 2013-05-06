require 'bundler'
Bundler.require

class App < Sinatra::Base

  configure do
    enable :sessions
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite://test.db')
  end

  configure :development do

    require "sinatra/reloader"
    register Sinatra::Reloader

    require 'rack-livereload'
    use Rack::LiveReload

    DataMapper.setup(:default, 'postgres://nobuti:awesome002@localhost/invoices')
  end

  Dir[File.join(".", "models/**/*.rb")].each do |f|
    require f
  end
  DataMapper.finalize
  DataMapper.auto_upgrade!

  Dir[File.join(".", "helpers/**/*.rb")].each do |f|
    require f
  end

  use Rack::MethodOverride
  helpers SomeHelpers

  get '/' do
    erb :login
  end

  get '/test' do
    erb :test
  end

  get '/invoice' do
    erb :invoice
  end

  get '/nicemondays' do
    erb :nicemondays
  end

  not_found do
    halt 404, erb(:'404')
  end
end