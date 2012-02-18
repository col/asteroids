#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require './player'
require './asteroid'

include Rubygame
include Rubygame::Sprites

class Game

  include EventHandler::HasEventHandler

  attr_reader :asteroids, :bullets

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

    # Create some asteroids
    @asteroids = Group.new
    @asteroids << BigAsteroid.new([100,100], 45, 30, self)
    @asteroids << BigAsteroid.new([500,400], 170, 45, self)

    @bullets = Group.new
  end

  def add_bullet(bullet)
    #make_magic_hooks_for( bullet, { YesTrigger.new() => :handle } )
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

    @bullets.each do |bullet|
      bullet.kill unless bullet.alive?
    end

    @bullets.update(event)
    @asteroids.update(event)

    @bullets.collide_group( @asteroids ) do |bullet, asteroid|
      asteroid.hit
      bullet.kill
    end

    if @player.collide_group(@asteroids).size > 0
      throw :quit
    end

    unless @asteroids.size > 0
      @asteroids << BigAsteroid.new([100,100], 45, 30, self)
      @asteroids << BigAsteroid.new([500,400], 170, 45, self)
    end
  end

  def draw
    # Clear the screen.
    @screen.fill( :black )

    # Draw game objects
    @player.draw @screen
    @bullets.draw @screen
    @asteroids.draw @screen

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