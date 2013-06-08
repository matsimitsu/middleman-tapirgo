# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-tapirgo/pkg-info"

Gem::Specification.new do |s|
  s.name        = Middleman::Tapirgo::PACKAGE
  s.version     = Middleman::Tapirgo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Beekman"]
  s.email       = ["robert@matsimitsu.nl"]
  s.homepage    = "http://github.com/matsimitsu/middleman-tapirgo/"
  s.summary     = %q{Sync middleman content to TapirGO}
  s.description = %q{Sync middleman content to TapirGO}
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 3.0.0"])

  # Additional dependencies
  s.add_runtime_dependency("json")
end
