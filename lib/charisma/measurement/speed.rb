module Charisma
  class Measurement
    # Speed, in meters per second
    class Speed < Measurement
      units :meters_per_second => 'm/s'
    end
    # Velocity is an SI-accepted alias for speed
    Velocity = Speed
  end
end
