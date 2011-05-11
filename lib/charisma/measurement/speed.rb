module Charisma
  class Measurement
    class Speed < Measurement
      units :meters_per_second => 'm/s'
    end
    Velocity = Speed
  end
end
