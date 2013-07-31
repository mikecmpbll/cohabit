# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cohabit/version'

Gem::Specification.new do |spec|
  spec.name          = "cohabit"
  spec.version       = Cohabit::VERSION
  spec.authors       = ["Mike Campbell"]
  spec.email         = ["mike@wordofmike.net"]
  spec.description   = %q{Handle application scoping for multi-tenant applications with table scopes.}
  spec.summary       = %q{Scope multi-tenant applications.}
  spec.homepage      = "http://github.com/mikecmpbll/cohabit"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "active_record"
  spec.add_dependency "active_support"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
