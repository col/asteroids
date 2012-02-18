require 'rubygame'
include Rubygame

class Player

  include Sprites::Sprite

  def initialize
    super()

    @image = Surface.new [16, 16]
    @image.draw_line [8, 0], [0,16], [255, 255, 255]
    @image.draw_line [8, 0], [16,16], [255, 255, 255]
    @image.draw_line [0, 16], [8,12], [255, 255, 255]
    @image.draw_line [16, 16], [8,12], [255, 255, 255]

    @rect = Rect.new [100,100], [16, 16]
  end

end