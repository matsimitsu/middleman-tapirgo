require 'bundler'
Bundler::GemHelper.install_tasks

task :test => ['rspec']
require "middleman-tapirgo/pkg-info"

PACKAGE = "#{Middleman::Tapirgo::PACKAGE}"
VERSION = "#{Middleman::Tapirgo::VERSION}"

task :package do
  system "gem build #{PACKAGE}.gemspec"
end


task :release => :package do
  system "gem push #{PACKAGE}-#{VERSION}"
end

task :default => :test
