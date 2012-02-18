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
    x = @rect.centerx
    y = @rect.centery

    x += @velocity.x * dt
    y += @velocity.y * dt

    # Wrap the screen
    # TODO: use the screen width and height
    x = 0 if x > 640
    x = 640 if x < 0
    y = 0 if y > 480
    y = 480 if y < 0

    @rect.center = [x, y]
  end

end