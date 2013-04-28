require 'bundler'
Bundler.require

class App < Sinatra::Base

  configure do
    enable :sessions
  end

  configure :test do
    set :database, Sequel.connect('sqlite://test.db')
  end

  configure :development do
    require 'rake-pipeline'
    require 'rake-pipeline/middleware'
    use Rake::Pipeline::Middleware, 'Assetfile'

    require "sinatra/reloader"
    register Sinatra::Reloader

    require 'rack-livereload'
    use Rack::LiveReload

    set :database, Sequel.connect('postgres://nobuti:awesome002@localhost/invoices')
  end

  Dir[File.join(".", "models/**/*.rb")].each do |f|
    require f
  end

  Dir[File.join(".", "helpers/**/*.rb")].each do |f|
    require f
  end

  use Rack::MethodOverride
  helpers SomeHelpers

  get '/' do
    erb :index
  end

  not_found do
    halt 404, erb(:'404')
  end
end