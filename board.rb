require 'colorize'
require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }
    setup_board if setup
    @cursor = [0, 0]
  end

  def [](pos)
    @gird[pos.first][pos.last]
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def deep_dup
    duped_board = Board.new(false)

    [:white, :black].each do |color|
      pieces(color).each do |piece|
        duped_piece = Piece.new(board: duped_board, color: color, pos: piece.pos.dup)
        duped_board[duped_piece.pos] = duped_piece
      end
    end

    duped_board
  end

  def piece_at(pos)
    self.grid[pos.first][pos.last]
  end

  def pieces(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  def occupied?(pos)
    !!piece_at(pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end

  def move(start_pos, sequence)
    # raise InvalidMoveError unless occupied?(sequence.first)
    raise InvalidMoveError unless piece_at(start_pos).perform_moves(sequence)
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
    # @grid[6][4] = Piece.new(board: self, color: :white, pos: [6, 4])

    # Sequence Jump Test Case
    @grid[0][0] = Piece.new(board: self, color: :white, pos: [0, 0])
    @grid[1][1] = Piece.new(board: self, color: :black, pos: [1, 1])
    @grid[3][3] = Piece.new(board: self, color: :black, pos: [3, 3])


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

if $PROGRAM_NAME == "pry"
  board = Board.new
  piece = board.piece_at([0,0])
  piece.perform_moves([[2,2],[4,4]])
end
