# Charisma

Charisma provides a *superficiality framework* for Ruby objects. You can use it to:

* Provide a *curation strategy* for your class that defines which of its attributes are *superfically important.*
* Define *metadata* on these characteristics, such as measurements and units.
* Facilitate *appropriate presentation* of these characteristics (i.e., intelligent `#to_s`).

Charisma is all about how your objects look to the outside world. We use it within [CM1](http://carbon.brighterplanet.com) to facilitate the characterization of the flights, cars, etc. that we're performing carbon calculations on.

## Example

``` ruby
class Spaceship < SuperModel::Base # or ActiveRecord, or whatever
  attributes :window_count, :name, :size, :weight
  belongs_to :make, :class_name => 'SpaceshipMake', :primary_key => 'name'
  belongs_to :fuel, :class_name => 'SpaceshipFuel', :primary_key => 'name'
  belongs_to :destination, :class_name => 'Planet', :primary_key => 'name'
  
  include Charisma
  characterize do
    has :make, :display_with => :name
    has :fuel
    has :window_count do |window_count|
      "#{window_count} windows"
    end
    has :size, :measures => :length # uses Charisma::Measurements::Length
    has :weight, :measures => RelativeAstronomicMass
    has :name
    has :destination
  end
end
```
``` irb
irb(main):001:0> amaroq = Spaceship.new :size => 100, :window_count => 3, :make => SpaceshipMake.create(:name => 'Ford')
 => #<Spaceship:0xacd9ac4 ...>
irb(main):002:0> amaroq.characteristics[:size].to_s
 => "100 m"
irb(main):003:0> amaroq.characteristics[:size].feet
 => 328.08399000000003
irb(main):004:0> amaroq.characteristics[:window_count].to_s
 => "3 windows"
irb(main):005:0> amaroq.characteristics[:make].to_s
 => "Ford"
```

## Characterizing your class

Charisma uses a DSL within a `characterize` block to define your class's attribute curation strategy:

``` ruby
class Foo
  # ...
  include Charisma
  characterize do
    # Characteristics go here
  end
end
```

### Simple (scalar) characteristics

How do you define characteristics? The simplest way looks like this:

``` ruby
characterize do
  has :color
end
```

Charisma will obtain the `color` characteristic for an instance by calling its `#color` method.

``` irb
irb(main):001:0> Foo.new(:color => 'Blue').characteristics[:color].to_s
 => Blue
```

### Fancy characteristics

Of course, this isn't extremely useful. Things get more interesting when you want the characteristic to present itself usefully:

``` ruby
characterize do
  has :color do |color|
    "##{Color.find_by_name(color).hex}"
  end
end
```
``` irb
irb(main):001:0> Foo.new(:color => 'black').characteristics[:color].to_s
 => #000000
```

Or perhaps you're using an association:

``` ruby
characterize do
  has :color, :display_with => :hex # If unspecified, Charisma will try #as_characteristic and #to_s on the associated object, in that order 
end
```
``` irb
irb(main):001:0> Foo.new(:color => Color.find_by_name('black')).characteristics[:color].to_s
 => #000000
```

### Measured characteristics

Some characteristics represent measured values like *length*. You can specify that like so:

``` ruby
characterize do
  has :size, :measures => Length 
end
```
``` ruby
class Length < Charisma::Measurement # Don't need to inherit if you want to DIY
  units :meters => 'm' 
end
```
``` irb
irb(main):001:0> Foo.new(:size => 10).characteristics[:size].to_s
 => 10 m
```

Charisma has some [convenient measurements](https://github.com/brighterplanet/charisma/tree/master/lib/charisma/measurement) baked in:

``` ruby
characterize do
  has :size, :measures => Charisma::Measurement::Length 
end
```

Built-in measurements can be referenced with a shortcut:

``` ruby
characterize do
  has :size, :measures => :length 
end
```

Charisma uses [Conversions](https://github.com/seamusabshere/conversions) to provide useful unit conversion methods:

``` irb
irb(main):001:0> Foo.new(:size => 10).characteristics[:size].feet
 => 32.808399000000003
```

## Copyright

Copyright (c) 2011 Andy Rossmeissl. See LICENSE for details.
