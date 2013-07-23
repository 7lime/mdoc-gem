$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'mdoc/version'

Gem::Specification.new 'mdoc', Mdoc::VERSION do |s|
  s.description       = 'A tool for convert document between several different formats.'
  s.summary           = 'A tool for convert document between several different formats.'
  s.authors           = ['Huang Wei']
  s.email             = 'huangw@pe-po.com'
  s.homepage          = 'https://github.com/7lime/mdoc-gem'
  s.files             = `git ls-files`.split("\n") - %w[.gitignore]
  s.executables       << 'mdoc'
  s.test_files        = Dir.glob('{spec,test}/**/*.rb')

  s.add_dependency 'kramdown'
  s.add_dependency 'tilt'
  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'simplecov', '~> 2.5'
end

