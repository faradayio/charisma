$:.push File.expand_path("../lib", __FILE__)
require 'charisma/version'

Gem::Specification.new do |s|
  s.name = 'charisma'
  s.version = Charisma::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Andy Rossmeissl', 'Seamus Abshere']
  s.email = 'andy@rossmeissl.net'
  s.homepage = 'http://github.com/brighterplanet/charisma'
  s.summary = %Q{Curate your rich Ruby objects' attributes}
  s.description = %Q{Define strategies for accessing and displaying a subset of your classes' attributes}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.markdown',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency 'activesupport'
  s.add_dependency 'blockenspiel'
  s.add_dependency 'conversions'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'bueller'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'supermodel'
end

