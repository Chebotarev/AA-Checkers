require 'colorize'
require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def [](pos)
    @gird[pos.first][pos.last]
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def piece_at(pos)
    self[pos]
  end

  def move(start_pos, end_pos)
    piece_at(start_pos).perform_slide(end_pos)
  end

  def render
    system('clear')
    puts (0..8).to_a.join(" ")
    @grid.each_with_index do |row, i|
      print i
      row.each_with_index do |space, j|
        if (i + j).odd?
          background = :light_black
        else
          background = :light_blue
        end

        if space.nil?
          print "  ".colorize(background: background)
        else
          print "#{space.symbol} ".colorize(color: space.color, background: background)
        end
      end
      puts i
    end
    puts (0..8).to_a.join(" ")

  end

  def setup_board
    @grid.each_with_index do |row, i|
      row.each_with_index do |space, j|
        if (i + j).odd? && i < 3
          self[[i, j]] = Piece.new(board: self, color: :white, pos: [i, j])
        elsif
           (i + j).odd? && i > 4
          self[[i, j]] = Piece.new(board: self, color: :black, pos: [i, j])
        end
      end
    end
  end
end
