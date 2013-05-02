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