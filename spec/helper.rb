require 'bundler/setup'

if Bundler.definition.specs['debugger'].first
  require 'debugger'
elsif Bundler.definition.specs['ruby-debug'].first
  require 'ruby-debug'
end

require 'charisma'

require 'support/planet'
require 'support/spaceship'
require 'support/spaceship_fuel'
require 'support/spaceship_make'
