require 'rubygems'
require 'bundler'
Bundler.require

require 'rspec/core/rake_task'

ENV['RACK_ENV'] ||= 'development'

task :default => :help

desc "Show help menu"
task :help do
  puts "Available rake tasks: "
  puts "rake deploy - Deploy to webfaction"
  puts "rake spec - Run specs and calculate coverage"
  puts "rake db:version - Prints current schema version"
  puts "rake db:migrate - Perform migration up to latest migration available"
  puts "rake db:rollback - Perform rollback to specified target or full rollback as default"
  puts "rake db:nuke - Nuke the database (drop all tables)"
  puts "rake reset - Perform migration reset (full rollback and migration)"
end

desc "Run specs"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

user = 'nobuti'

app_name = 'makingmoney'
app_dir  = "/home/#{user}/webapps/#{app_name}"

desc 'Deploy to server'
task :deploy, :password do |t, args|
  puts 'Deploying to server...'

  # http://linux.die.net/man/1/rsync
  # Push: rsync [OPTION...] SRC... [USER@]HOST:DEST
  success =  system "rsync --exclude-from .excludes -rltvz -e ssh . #{user}@#{user}.webfactional.com:#{app_dir}"

  if success
    require 'net/ssh'
    Net::SSH.start("#{user}.webfactional.com", user, :password => args[:password]) do |ssh|
      commands = [
        'export RACK_ENV=production',
        "export GEM_HOME=#{app_dir}/gems",
        "export PATH=#{app_dir}/bin:$PATH",
        "cd #{app_dir}",
        'bundle install --without=development',
        'rake thin:restart'
      ].join ' && '

      ssh.exec commands
    end
  end
end

namespace :db do
  require "sequel"
  Sequel.extension :migration

  desc "Select enviroment"
  task :environment, :env do |cmd, args|
    ENV["RACK_ENV"] = args[:env] || "development"
    puts "Enviroment: #{ENV["RACK_ENV"]}"

    if ENV["RACK_ENV"] == "production"
      database = 'postgres://nicemondays:porfinesviernes@127.0.0.1/checks_db'
    end

    if ENV["RACK_ENV"] == "development"
      database = 'postgres://nobuti:awesome002@localhost/invoices'
    end

    if ENV["RACK_ENV"] == "test"
      database = 'sqlite://test.db'
    end

    DB = Sequel.connect(database)
  end

  desc "Prints current schema version"
  task :version, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['db:environment'].invoke(env)
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['db:environment'].invoke(env)
    Sequel::Migrator.run(DB, "migrations")
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :env, :target do |t, args|

    env = args[:env] || "development"
    Rake::Task['db:environment'].invoke(env)

    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, "migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Nuke the database (drop all tables)"
  task :nuke, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['db:environment'].invoke(env)

    DB.tables.each do |table|
      DB.run("DROP TABLE #{table}")
    end
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset, :env do |t, args|
    env = args[:env] || "development"
    Rake::Task['db:environment'].invoke(env)

    Sequel::Migrator.run(DB, "migrations", :target => 0)
    Sequel::Migrator.run(DB, "migrations")
    Rake::Task['db:version'].execute
  end
end