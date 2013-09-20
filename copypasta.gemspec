# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copypasta/version'

Gem::Specification.new do |spec|
  spec.name          = "copypasta"
  spec.version       = Copypasta::VERSION
  spec.authors       = ["Robin Harrison"]
  spec.email         = ["merlinc@thecourtsofchaos.com"]
  spec.description   = "Copypasta is a command line tool for copying non-Application bundle binary files from one computer to another by copying and relinking any library dependencies"
  spec.summary       = "Copypasta copies binaries files and dependencies from one Mac to another"
  spec.homepage      = "https://github.com/merlinc/copypasta"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.3.0')
  spec.add_development_dependency('rspec')
end
