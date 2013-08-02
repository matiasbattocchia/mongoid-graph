# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/graph/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-graph"
  spec.version       = Mongoid::Graph::VERSION
  spec.authors       = ["Matías Battocchia"]
  spec.email         = ["matias@riseup.net"]
  spec.description   = %q{A graph structure for Mongoid documents.}
  spec.summary       = %q{This gem provides graph database functionality
                          for Mongoid, allowing documents to be used as
                          graph elements.}
  spec.homepage      = "https://github.com/matiasbattocchia/mongoid-graph"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
end
