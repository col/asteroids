require 'rubygame'
require './game_object'
include Rubygame

class Asteroid < GameObject

  def initialize(position, size, angle, speed, game)
    super(position, [100,100])

    @game = game

    radians = -(angle+90) * Math::PI / 180
    @velocity = Ftor.new_am radians, speed

    # draw the asteroid (a circle will do for now)
    @colour = [255, 255, 255]
    center = size.map { |x| x/2 }
    @image.draw_circle center, center[0]-0.1, @colour
  end

end

class BigAsteroid < Asteroid

  def initialize(position, angle, speed, game)
    super(position, [100,100], angle, speed, game)
  end

  def hit
    @game.asteroids << SmallAsteroid.new(@rect.center, @velocity.angle+15, @velocity.magnitude*1.2, @game)
    @game.asteroids << SmallAsteroid.new(@rect.center, @velocity.angle-15, @velocity.magnitude*1.2, @game)
    self.kill
  end

end

class SmallAsteroid < Asteroid

  def initialize(position, angle, speed, game)
    super(position, [50,50], angle, speed, game)
  end

  def hit
    self.kill
  end

end