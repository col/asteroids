#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require './player'
require './asteroid'

include Rubygame

class Game

  include EventHandler::HasEventHandler

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
      QuitRequested => :quit
    }
    make_magic_hooks( hooks )

    # Create a player
    @player = Player.new [100,100], [16,16]
    # Make event hook to pass all events to @ship#handle().
    make_magic_hooks_for( @player, { YesTrigger.new() => :handle } )

    # Create some asteroids
    @asteroids = []
    #@asteroids << Asteroid.new([200,200], [100,100])
    #@asteroids << Asteroid.new([300,300], [60,60])
  end

  def run
    catch(:quit) do
      loop do
        update
        draw
        # Tick the clock and add the TickEvent to the queue.
        @queue << @clock.tick
      end
    end
  end

  def update

    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events

    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end

  end

  def draw
    # Clear the screen.
    @screen.fill( :black )

    @player.draw @screen
    @asteroids.each do |asteroid|
      if @player.collide_sprite? asteroid
        throw :quit
      end
      asteroid.draw @screen
    end
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