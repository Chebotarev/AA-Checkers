require 'colorize'
require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
    @cursor = [0, 0]
  end

  def [](pos)
    @gird[pos.first][pos.last]
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def piece_at(pos)
    self.grid[pos.first][pos.last]
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end

  def move(start_pos, end_pos)
    raise InvalidMove unless occupied?(start_pos)
    raise InvalidMove unless piece_at(start_pos).perform_slide(end_pos)
  end

  def render
    system('clear')
    puts " " + (0..7).to_a.join(" ")
    @grid.each_with_index do |row, i|
      print i
      row.each_with_index do |space, j|
        if @cursor == [i, j]
          background = :yellow
        elsif (i + j).odd?
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
    puts " " + (0..7).to_a.join(" ")

  end

  def setup_board
    # Kinged Test Case
    @grid[6][4] = Piece.new(board: self, color: :white, pos: [6, 4])

    # @grid.each_with_index do |row, i|
    #   row.each_with_index do |space, j|
    #     if (i + j).odd? && i < 3
    #       self[[i, j]] = Piece.new(board: self, color: :white, pos: [i, j])
    #     elsif
    #        (i + j).odd? && i > 4
    #       self[[i, j]] = Piece.new(board: self, color: :black, pos: [i, j])
    #     end
    #   end
    # end
  end
end
