require 'rubygame'
require './game_object'
include Rubygame

class Asteroid < GameObject

  def initialize(position, size, angle, speed, game)
    super(position, size, game)

    radians = -(angle+90) * Math::PI / 180
    @velocity = Ftor.new_am radians, speed

    # Draw the asteroid (a circle will do for now)
    center = size.map { |x| x/2 }
    @image.draw_circle center, center[0]-0.1, @colour
    @image.set_alpha 0,0
  end

  # Detect a collision with a circle by checking if the distance
  # between the point and the circles center is smaller than it's radius.
  def collide_point?(point)
    distance = Math.hypot(point[0]-@rect.center[0],point[1]-@rect.center[1])
    distance < @rect.w/2
  end

  # Override to detect collision between circle and rect.
  def collide_rect?(rect)
    return true if collide_point?(rect.topleft)
    return true if collide_point?(rect.topright)
    return true if collide_point?(rect.bottomleft)
    collide_point?(rect.bottomright)
  end

end

class BigAsteroid < Asteroid

  def initialize(position, angle, speed, game)
    super(position, [100,100], angle, speed, game)
  end

  def hit
    # Add two small asteroids based on the parent asteroid
    (1..2).each do
      # randomise the position of the new asteroid but keep it within its parent
      position = @rect.topleft.map { |i| i + rand(@rect.w) }
      # randomise the angle but keep it within +/- 90 degrees of the parent angle
      degrees = -(@velocity.angle * 180 / Math::PI)-90
      degrees += rand(180) - 90
      # increase the speed by a random amount (between 100% - 20%)
      speed = @velocity.magnitude * (1 + rand())
      @game.add_asteroid SmallAsteroid.new(position, degrees, speed, @game)
    end
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