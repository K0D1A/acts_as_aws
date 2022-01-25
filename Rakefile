require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :rebuild_db do
  Rake::Task['app:db:drop'].invoke
  Rake::Task['app:db:create'].invoke
  Rake::Task['app:db:migrate'].invoke
end

task :all => [:rebuild_db, :test]

task default: :test
