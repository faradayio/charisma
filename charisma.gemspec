require File.expand_path('../lib/charisma/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'charisma'
  s.version = Charisma::VERSION
  s.authors = ['Andy Rossmeissl', 'Seamus Abshere']
  s.email = 'andy@rossmeissl.net'
  s.homepage = 'https://github.com/brighterplanet/charisma'
  s.summary = %Q{Curate your rich Ruby objects' attributes}
  s.description = %Q{Define strategies for accessing and displaying a subset of your classes' attributes}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency 'activesupport'
  s.add_dependency 'conversions'

  s.add_development_dependency 'bueller'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'supermodel'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'yard'
end
