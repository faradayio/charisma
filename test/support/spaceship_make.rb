require 'supermodel'

class SpaceshipMake < SuperModel::Base
  has_many :spaceships
  attributes :name
  self.primary_key = :name 
end
