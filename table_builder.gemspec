# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "table_builder/version"

Gem::Specification.new do |s|
  s.name        = "table_builder"
  s.version     = TableBuilder::VERSION
  s.authors     = ["Petrik de Heus"]
  s.email       = ["pupeno@watuhq.com"]
  s.homepage    = ""
  s.summary     = %q{Rails builder for creating tables and calendars inspired by ActionView's FormBuilder.}
  s.description = %q{Rails builder for creating tables and calendars inspired by ActionView's FormBuilder.}

  s.rubyforge_project = "table_builder"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
