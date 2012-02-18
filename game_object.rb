require 'rubygame'
require 'rubygame/ftor'
include Rubygame

class GameObject

  include Sprites::Sprite
  include EventHandler::HasEventHandler

  def initialize(position, size)
    super()

    @image = Surface.new size
    @rect = Rect.new position, size

    @px, @py = position[0], position[1] # Current Position
    @velocity = Ftor.new 0, 0

    # Create event hooks in the easiest way.
    make_magic_hooks(
      # Send ClockTicked events to #update()
      ClockTicked => :update
    )
  end

  def update( event )
    dt = event.seconds # Time since last update
    update_pos( dt )
  end

  # Update the position based on the velocity and the time since last
  # update.
  def update_pos( dt )
    @px += @velocity.x * dt
    @py += @velocity.y * dt

    # Wrap the screen
    # TODO: use the screen width and height
    @px = 0 if @px > 640
    @px = 640 if @px < 0
    @py = 0 if @py > 480
    @py = 480 if @py < 0

    @rect.center = [@px, @py]
  end

end