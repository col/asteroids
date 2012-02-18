require 'rubygame'
require './game_object'
include Rubygame

class Player < GameObject

  def initialize(position, size)
    super

    # draw the players shape
    @colour = [255, 255, 255]
    @image.draw_line [8, 0], [0,16], @colour
    @image.draw_line [8, 0], [16,16], @colour
    @image.draw_line [0, 16], [8,12], @colour
    @image.draw_line [16, 16], [8,12], @colour
  end

end