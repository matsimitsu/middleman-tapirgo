require 'bundler'
Bundler::GemHelper.install_tasks

task :test => ['rspec']
require "middleman-tapirgo/pkg-info"

PACKAGE = "#{Middleman::Tapirgo::PACKAGE}"
VERSION = "#{Middleman::Tapirgo::VERSION}"

task :package do
  system "gem build #{PACKAGE}.gemspec"
end

task :install => :package do
  Dir.chdir("pkg") do
    system "gem install #{PACKAGE}-#{VERSION}"
  end
end

task :release => :package do
  Dir.chdir("pkg") do
    system "gem push #{PACKAGE}-#{VERSION}"
  end
end

task :default => :test
