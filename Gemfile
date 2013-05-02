source 'https://rubygems.org'

ruby '1.9.3'

gem 'sinatra'
gem 'foreman'
gem 'thin'
gem 'rake'
gem 'net-ssh'
gem 'sequel'
gem 'pg'
gem 'json'
gem 'pony', '~> 1.4'
gem 'bcrypt-ruby', :require => 'bcrypt'
# gem 'pdfkit', :require => 'pdfkit'

group :development do
  gem 'guard-sass', :require => false
  gem 'sinatra-reloader'
  gem 'guard-livereload'
  gem 'guard-coffeescript'
  gem 'rack-livereload'
  gem 'guard-sprockets'
  gem 'rb-fsevent', '~> 0.9'
  gem 'therubyracer'
  gem 'uglifier'
end

group :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
end