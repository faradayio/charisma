#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test => :spec

require 'bueller'
Bueller::Tasks.new

task :start_coverage do
  SimpleCov.start
end
task :coverage => [:start_coverage, :test]

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new do |y|
  y.options << '--no-private'
end
