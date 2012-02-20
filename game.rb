#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require './player'
require './asteroid'

include Rubygame
include Rubygame::Sprites

class Game

  include EventHandler::HasEventHandler

  attr_reader :asteroids, :bullets, :screen

  def initialize
    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Asteriods"

    @clock = Rubygame::Clock.new
    @clock.target_framerate = 50
    @clock.calibrate
    @clock.enable_tick_events

    @queue = Rubygame::EventQueue.new
    @queue.enable_new_style_events
    # Don't care about mouse movement, so let's ignore it.
    @queue.ignore = [MouseMoved]

    hooks = {
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit,
      ClockTicked => :update
    }
    make_magic_hooks( hooks )

    # Create a player
    @player = Player.new [@screen.width/2,@screen.height/2], self
    # Make event hook to pass all events to @player#handle().
    make_magic_hooks_for( @player, { YesTrigger.new() => :handle } )

    # Create an asteroids group
    @asteroids = Group.new
    (1..2).each { add_asteroid }

    # Create a bullets group
    @bullets = Group.new
  end

  # Adds the asteroid to the group or creates a random asteroid if none provided
  def add_asteroid(asteroid = nil)
    if asteroid
      @asteroids << asteroid
    else
      @asteroids << BigAsteroid.new([rand(@screen.w),rand(@screen.h)], rand(360), rand(50)+30, self)
    end
  end

  # Adds the bullet to the group
  def add_bullet(bullet)
    @bullets << bullet
  end

  def run
    catch(:quit) do
      loop do
        handle_events
        draw
        # Tick the clock and add the TickEvent to the queue.
        @queue << @clock.tick
      end
    end
  end

  def handle_events
    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events

    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end
  end

  def update(event)
    @bullets.update(event)
    @asteroids.update(event)

    # Handle collisions between asteroids and bullets
    @asteroids.collide_group( @bullets ) do |asteroid, bullet|
      bullet.kill
      asteroid.hit
    end

    # Handle collisions between asteroids and the player
    asteroids_hit = @player.collide_group(@asteroids)
    if asteroids_hit.size > 0
      asteroids_hit.each { |a| a.hit }
      @player.rect.center = [@screen.w/2, @screen.h/2]
    end

    # If all asteroids are hit, add some more.
    (1..rand(5)).each { add_asteroid } if @asteroids.size == 0
  end

  def draw
    # Clear the screen.
    @screen.fill( :black )

    # Draw game objects
    @bullets.draw @screen
    @asteroids.draw @screen
    @player.draw @screen

    # Update screen
    @screen.update
  end

  # Quit the game
  def quit
    puts "Quitting!"
    throw :quit
  end

end

game = Game.new
game.run