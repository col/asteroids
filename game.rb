#!/bin/env ruby

require 'rubygems'
require 'rubygame'
require './player'

include Rubygame

class Game
  def initialize
    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Asteriods"

    @player = Player.new

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
    @screen.update
  end
end

game = Game.new
game.run