require 'rubygame'
include Rubygame

class GameObject

  include Sprites::Sprite

  def initialize(position, size)
    super()

    @image = Surface.new size
    @rect = Rect.new position, size
  end

end