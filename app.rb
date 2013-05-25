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
  use Rack::Flash, :sweep => true
  helpers SomeHelpers

  get '/' do
    passing_logged!
    erb :login
  end

  post '/login' do
    user = User.first(:email => params[:email], :enabled => true)
    if user
      if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
        session[:token] = user.token
        session[:user] = user.id
        redirect "/dashboard"
      else
        flash[:error] = "Wrong password"
        redirect "/login"
      end
    else
      flash[:error] = "That user not even exists!"
      redirect "/login"
    end
  end

  get '/logout' do
    session[:token] = nil
    session[:id] = nil
    redirect '/'
  end

  post '/signup' do
    user = User.create(params[:user])
    user.password_salt = BCrypt::Engine.generate_salt
    user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
    if user.save
      user.profile = Profile.create(:name => "Jhon Doe", :address => "42th Elm Street", :nif => "12345678A", :iva => 21.0, :irpf => 21.0)
      user.profile.save

      user.driver = Driver.create(:counter => 1, :year => DateTime.now.strftime("%g"))
      user.driver.save

      session[:user] = user.token
      "User created sucessfully!"
    else
      user.errors.full_messages
    end
  end

  get '/invoices' do
  end

  post '/invoice' do
    invoice = Invoice.create(params[:invoice])
    if invoice.save
      content_type 'json'
      {:invoice => invoice.id}.to_json
    else
      content_type 'json'
      {:error => invoice.errors.full_messages}.to_json
    end
  end

  get '/dashboard' do
    protected!
    user = User.first(:id => session[:user])
    year = Time.new.year
    @clientes = user.clients
    @years = user.invoices.years
    @invoices = user.invoices.all(:date => Date.parse("#{year}-01-01") .. Date.parse("#{year}-12-31"))
  end

  get '/year/:year' do
    protected!
    user = User.first(:id => session[:user])
    year = params[:year]
    @clientes = user.clients
    @years = user.invoices.years
    @invoices = user.invoices.all(:date => Date.parse("#{year}-01-01") .. Date.parse("#{year}-12-31"))
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