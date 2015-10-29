# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mdoc/version'

Gem::Specification.new do |spec|
  spec.name          = "mdoc"
  spec.version       = Mdoc::VERSION
  spec.authors       = ["Huang Wei"]
  spec.email         = ["huangw@pe-po.com"]
  spec.summary       = %q{Markdown to html converter with plug-in processors.}
  spec.description   = %q{Based on kramdown or redcloth, convert markdown to html, with pre/post plug-in processors to implement custom extensions.}
  spec.homepage      = "https://github.com/7lime/mdoc-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "tilt", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.4"
end
