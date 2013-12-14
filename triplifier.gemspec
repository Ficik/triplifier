# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'triplifier/version'

Gem::Specification.new do |spec|
  spec.name          = "triplifier"
  spec.version       = Triplifier::VERSION
  spec.authors       = ["Standa Fifik"]
  spec.email         = ["standa.fifik@gmail.com"]
  spec.description   = %q{module to simplify conversion to RDF triplets}
  spec.summary       = %q{module to simplify conversion to RDF triplets}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
