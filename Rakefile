# frozen_string_literal: true.

desc 'Run Terminal pug-bot'
task :prepare do
  sh %{ ruby setup.rb }
end

desc 'Run tests'
task :test do
  sh %{ rspec spec }
end

desc 'Run Rubocop check'
task :cop do
  sh %{ rubocop }
end

desc 'Verify everything is good before merge'
task :flightcheck => [:cop, :test] do
end
