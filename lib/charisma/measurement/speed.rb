module Charisma
  class Measurement
    # Speed, in metres per second
    class Speed < Measurement
      units :metres_per_second => 'm/s'
    end
    # Velocity is an SI-accepted alias for speed
    Velocity = Speed
  end
end
