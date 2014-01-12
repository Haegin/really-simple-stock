# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'really-simple-stock/version'

Gem::Specification.new do |spec|
  spec.name          = "really-simple-stock"
  spec.version       = ReallySimpleStock::VERSION
  spec.authors       = ["Harry Mills"]
  spec.email         = ["harry@haeg.in"]
  spec.summary       = %q{A simple stock management system.}
  spec.description   = %q{A simple stock management system implemented in the functional core; imperative shell style.}
  spec.homepage      = "https://github.com/Haegin/really-simple-stock"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-ansi"
end
