# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radius/template/version'

Gem::Specification.new do |spec|
  spec.name          = "radius-template"
  spec.version       = RadiusTemplate::VERSION
  spec.authors       = ["Fourmach", 'José Galisteo Ruiz']
  spec.email         = ["ceritium@gmail.com"]
  spec.description   = %q{Simple Ruby on Rails wrapper around radius gem}
  spec.summary       = %q{Simple Ruby on Rails wrapper around radius gem}
  spec.homepage      = "https://github.com/fourmach/radius-template"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
