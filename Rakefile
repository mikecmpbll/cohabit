require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = ['test/all_tests.rb'] #FileList['test/*_test.rb']
  # t.verbose = true
end

desc "Run tests"
task :default => :test