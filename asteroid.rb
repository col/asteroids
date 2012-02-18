require 'rubygame'
require './game_object'
include Rubygame

class Asteroid < GameObject

  def initialize(position, size)
    super

    # draw the asteroid (a circle will do for now)
    @colour = [255, 255, 255]
    center = size.map { |x| x/2 }
    @image.draw_circle center, center[0]-0.1, @colour
  end

end