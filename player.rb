require 'rubygame'
require './game_object'
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

class Player < GameObject

  include EventHandler::HasEventHandler

  def initialize(position, size)
    super

    # draw the players shape
    @colour = [255, 255, 255]
    @image.draw_line [8, 0], [0,16], @colour
    @image.draw_line [8, 0], [16,16], @colour
    @image.draw_line [0, 16], [8,12], @colour
    @image.draw_line [16, 16], [8,12], @colour
    @orig = @image.clone

    @px, @py = position[0], position[1] # Current Position
    @vx, @vy = 0, 0 # Current Velocity
    @ax, @ay = 0, 0 # Current Acceleration
    @rotation = 0
    @rotation_speed = 4

    @max_speed = 400.0 # Max speed on an axis
    @accel = 5
    @deceleration = 0.99

    @keys = [] # Keys being pressed

    # Create event hooks in the easiest way.
    make_magic_hooks(
      # Send keyboard events to #key_pressed() or #key_released().
      KeyPressed => :key_pressed,
      KeyReleased => :key_released,
      # Send ClockTicked events to #update()
      ClockTicked => :update
    )

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

    update_accel
    update_vel( dt )
    update_pos( dt )
  end

  def degrees_to_radians(degrees)

  end

  # Update the acceleration based on what keys are pressed.
  def update_accel

    # Rotation
    @rotation += @rotation_speed if @keys.include?( :left )
    @rotation -= @rotation_speed if @keys.include?( :right )
    @image = @orig.rotozoom(@rotation, 1) if @keys.include?( :left ) || @keys.include?( :right )

    # Acceleration
    if @keys.include?( :up )
      radians = @rotation * Math::PI / 180
      @ax -= Math.sin(radians) * @accel
      @ay -= Math.cos(radians) * @accel
    else
      @ax, @ay = 0, 0
    end

  end


  # Update the velocity based on the acceleration and the time since
  # last update.
  def update_vel( dt )
    @vx = update_vel_axis( @vx, @ax, dt )
    @vy = update_vel_axis( @vy, @ay, dt )
  end

  # Calculate the velocity for one axis.
  # v = current velocity on that axis (e.g. @vx)
  # a = current acceleration on that axis (e.g. @ax)
  #
  # Returns what the new velocity (@vx) should be.
  #
  def update_vel_axis( vel, accel, dt )

    # Apply slowdown if not accelerating.
    vel *= @deceleration if accel == 0

    # Apply acceleration
    vel += accel

    # Clamp speed so it doesn't go too fast.
    vel = @max_speed if vel > @max_speed
    vel = -@max_speed if vel < -@max_speed
    vel
  end


  # Update the position based on the velocity and the time since last
  # update.
  def update_pos( dt )
    @px += @vx * dt
    @py += @vy * dt

    # Wrap the screen
    # TODO: use the screen width and height
    @px = 0 if @px > 640
    @px = 640 if @px < 0
    @py = 0 if @py > 480
    @py = 480 if @py < 0

    @rect.center = [@px, @py]
  end

end