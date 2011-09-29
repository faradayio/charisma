class RelativeAstronomicMass < Charisma::Measurement # or don't inherit and provide everything yourself
  units :hollagrams => 'hg' 
  # before_ and after_ filters or some other reason to use this as opposed to Charisma::Measurements::Mass
end

Conversions.register :hollagrams, :supertons, 2
