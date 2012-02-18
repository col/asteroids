#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require './player'
require './asteroid'

include Rubygame

class Game
  def initialize
    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Asteriods"

    # Create a player
    @player = Player.new [100,100], [16,16]

    # Create some asteroids
    @asteroids = []
    @asteroids << Asteroid.new([200,200], [100,100])
    @asteroids << Asteroid.new([300,300], [60,60])

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
  end

  def run
    loop do
      update
      draw
      @clock.tick
    end
  end

  def update
    @queue.each do |ev|
      case ev
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end

  def draw
    @player.draw @screen
    @asteroids.each do |asteroid|
      asteroid.draw @screen
    end
    @screen.update
  end
end

game = Game.new
game.run