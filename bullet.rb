class Bullet < GameObject

  def initialize(position, vx, vy)
    super(position, [2, 2])

    # color the bullet
    @image.fill [255, 255, 255]
  end


end