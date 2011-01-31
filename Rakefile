require 'rake/testtask'

desc 'Default: run tests'
task :default => :test

desc 'Run tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'counter_examples'
  t.libs << 'examples'
  t.libs << 'support'
  t.pattern = '*examples/*.rb'
  t.verbose = true
end
