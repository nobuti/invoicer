require 'rubygems'
require 'bundler'
Bundler.require

require 'rspec/core/rake_task'

ENV['RACK_ENV'] ||= 'development'

task :default => :help

desc "Show help menu"
task :help do
  puts "Available rake tasks: "
  puts "rake thin:start - Start App"
  puts "rake thin:stop - Stop App"
  puts "rake thin:restart - Restart App"
  puts "rake deploy - Deploy to webfaction"
  puts "rake spec - Run specs and calculate coverage"
  puts "rake assets:precompile - Assets precompile"
end

desc "Run specs"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

namespace :assets do
  task :precompile, :env do |cmd, args|
    env = args[:env] || "development"
    ENV['RAKEP_MODE'] = env
    system "bundle exec rakep"
    puts 'compiled.'
  end
end

namespace :thin do

  desc 'Start the app'
  task :start do
    puts 'Starting...'
    system "bundle exec thin -s 1 -C config/config-#{ENV['RACK_ENV']}.yaml -R config.ru start"
    puts 'Started!'
  end

  desc 'Stop the app'
  task :stop do
    puts 'Stopping...'

    pids = File.join(File.dirname(__FILE__), 'tmp/pids')

    if File.directory?(pids)
      Dir.new(pids).each do |file|
        prefix = file.to_s
        if prefix[0, 4] == 'thin'
          puts "Stopping the server on port #{file[/\d+/]}..."
          system "bundle exec thin stop -Ptmp/pids/#{file}"
        end
      end
    end

    puts 'Stopped!'
  end

  desc 'Restart the application'
  task :restart do
    puts 'Restarting...'
    Rake::Task['thin:stop'].invoke
    Rake::Task['thin:start'].invoke
    puts 'Restarted!'
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