require 'rubygame'
require 'rubygame/ftor'
require './game_object'
require './bullet'
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

class Player < GameObject

  def initialize(position, game)
    super(position, [16,16])

    @game = game

    # draw the players shape
    @colour = [255, 255, 255]
    @image.draw_line [8, 0], [0,16], @colour
    @image.draw_line [8, 0], [16,16], @colour
    @image.draw_line [0, 16], [8,12], @colour
    @image.draw_line [16, 16], [8,12], @colour
    @orig = @image.clone

    @acceleration = Ftor.new 0, 0
    @rotation = 0
    @rotation_speed = 4

    @max_speed = 400.0    # Max speed on an axis
    @max_accel = 10       # Max acceleration
    @deceleration = 0.98  # Deceleration rate

    @keys = [] # Keys being pressed

    # Create event hooks in the easiest way.
    make_magic_hooks(
      # Send keyboard events to #key_pressed() or #key_released().
      KeyPressed => :key_pressed,
      KeyReleased => :key_released,
    )

    @time = 0
  end

  private

  # Add it to the list of keys being pressed.
  def key_pressed( event )
    @keys += [event.key]
  end

  # Remove it from the list of keys being pressed.
  def key_released( event )
    @keys -= [event.key]
  end

  # Update the ship state. Called once per frame.
  def update( event )
    dt = event.seconds # Time since last update
    @time += dt
    update_accel
    update_vel( dt )
    super
  end

  # Update the acceleration based on what keys are pressed.
  def update_accel

    if @keys.include?( :space ) && @time > 0.5
      # FIRE!!!
      @time = 0
      @game.add_bullet Bullet.new @rect.center, @rotation
    end

    # Rotation
    @rotation += @rotation_speed if @keys.include?( :left )
    @rotation -= @rotation_speed if @keys.include?( :right )
    @image = @orig.rotozoom(@rotation, 1) if @keys.include?( :left ) || @keys.include?( :right )

    # Acceleration
    if @keys.include?( :up )
      radians = @rotation * Math::PI / 180
      @acceleration.x -= Math.sin(radians)
      @acceleration.y -= Math.cos(radians)
      @acceleration.magnitude = @max_accel if @acceleration.magnitude > @max_accel
    else
      @acceleration.x, @acceleration.y = 0, 0
    end

  end


  # Update the velocity based on the acceleration and the time since
  # last update.
  def update_vel( dt )
    # Apply the acceleration to the current velocity
    if @acceleration.magnitude > 0
      @velocity += @acceleration
    else
      @velocity *= @deceleration
    end

    # Cap the speed so the player doesn't go too fast
    @velocity.magnitude = @max_speed if @velocity.magnitude > @max_speed
  end

end