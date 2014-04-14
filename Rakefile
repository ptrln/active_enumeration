require 'rubygems'
require 'rake'
require 'rake/testtask'
require File.expand_path('../lib/active_enumeration/version', __FILE__)

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :default => 'test'

desc 'Builds the gem'
task :build do
  sh "gem build active_enumeration.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
  sh "gem install ./active_enumeration-#{ActiveEnumeration::VERSION}.gem"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{ActiveEnumeration::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{ActiveEnumeration::VERSION}"
  sh "gem push active_enumeration-#{ActiveEnumeration::VERSION}.gem"
end