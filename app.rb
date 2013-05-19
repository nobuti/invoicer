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

    require 'better_errors'
    use BetterErrors::Middleware

    DataMapper.setup(:default, 'postgres://nobuti:awesome002@localhost/invoicer')
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
    passing_logged!
    erb :login
  end

  post '/login' do
    user = User.first(:email => params[:email])
    if user
      if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
        session[:token] = user.token
        "Logged!"
      else
        "Wrong password"
      end
    else
      "That user not even exists!"
    end
  end

  get '/logout' do
    session[:token] = nil
    redirect '/'
  end

  post '/signup' do
    user = User.create(params[:user])
    user.password_salt = BCrypt::Engine.generate_salt
    user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
    if user.save
      session[:user] = user.token
      "User created sucessfully!"
    else
      user.errors.full_messages
    end
  end

  get '/dashboard' do
    "Dashboard"
  end
  # Borrowed from https://github.com/raul/jet-pack
  # Catch-all: just tries to find and render a view based on the request path
  get "/*" do
    render_from_request_path(request.path_info)
  end

  protected

  # Tilt does something like this but doesn't get exposed in Sinatra
  def render_from_request_path(path)
    if view_path = view_path_from_request_path(request.path_info)
      ext = File.extname(view_path)
      if engine = ENGINES_BY_EXT[ext]
        view_basename = view_path.gsub(/#{ext}\Z/,'')
        send(engine, view_basename.to_sym)
      else
        halt(500, "Unkwnown rendering engine for #{view_path}")
      end
    else
      halt 404, erb(:'404')
    end
  end

  # Traversal attacks are trapped by Sinatra's safe defaults:
  # https://github.com/sinatra/sinatra#configuring-attack-protection
  def view_path_from_request_path(path)
    path = 'index' if path.to_s == '/'
    file_path = Dir["#{settings.views}/#{path}.*"].first
    return file_path.gsub("#{settings.views}/", '') if file_path
  end

  ENGINES_BY_EXT = { '.slim' => :slim, '.md' => :markdown, '.erb' => :erb, '.haml' => :haml }

  ENGINES_BY_EXT.values.each do |engine|
    set engine, :layout_engine => :erb, :layout => :layout
  end
end