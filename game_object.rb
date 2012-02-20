require 'rubygame'
require 'rubygame/ftor'
include Rubygame

class GameObject

  include Sprites::Sprite
  include EventHandler::HasEventHandler

  def initialize(position, size, game)
    super()
    @game = game

    @image = Surface.new size
    @image.set_colorkey [0,0,0]
    @rect = Rect.new position, size
    @velocity = Ftor.new 0, 0
    @colour = [255, 255, 255]

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
    screen = @game.screen
    x = 0 if x > screen.w
    x = screen.w if x < 0
    y = 0 if y > screen.h
    y = screen.h if y < 0

    @rect.center = [x, y]
  end

end