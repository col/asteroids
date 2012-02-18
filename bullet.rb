require 'rubygame'
require 'rubygame/ftor'
require './game_object'
require './bullet'
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

class Bullet < GameObject

  def initialize(position, angle)
    super(position, [2, 2])

    # Start a counter to track how long to bullet has been alive for
    @time = 0
    @max_time = 0.6 # seconds the bullet will live for

    # Colour the bullet
    @image.fill [255, 255, 255]

    # Set the velocity of the bullet
    radians = -(angle+90) * Math::PI / 180
    @velocity = Ftor.new_am radians, 600
  end

  def alive?
    @time < @max_time
  end

  def update( event )
    @time += event.seconds # Time since last update
    super
  end

end