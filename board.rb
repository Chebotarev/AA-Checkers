require 'colorize'
require 'byebug'
require_relative 'piece.rb'

class Board
  attr_reader :cursor
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

  def won?
    won = false
    [:white, :black].each do |color|
      won = true if pieces(color).empty?
    end
    won
  end

  def move(start_pos, sequence)
    raise NoPieceError unless occupied?(start_pos)
    current_piece = piece_at(start_pos)
    if sequence[1].is_a?(Array)
      current_piece.perform_moves(sequence)
    elsif current_piece.slides.include?(sequence)
      raise InvalidMoveError unless current_piece.perform_slide(sequence)
    elsif current_piece.jumps.include?(sequence)
      raise InvalidMoveError unless current_piece.perform_jump(sequence)
    else
      raise InvalidMoveError
    end

    # raise InvalidMoveError unless piece_at(start_pos).perform_jump(end_pos)
  end

  def move_cursor(command_string)
    duped_cursor = @cursor.dup
    case command_string
    when "\e[A"
      @cursor[0] -= 1
    when "\e[B"
      @cursor[0] += 1
    when "\e[C"
      @cursor[1] += 1
    when "\e[D"
      @cursor[1] -= 1
    end
    @cursor = duped_cursor unless on_board?(@cursor)
    render
  end

  def render
    system('clear')
    # puts " " + (0..7).to_a.join(" ")
    @grid.each_with_index do |row, i|
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
          print "#{space.symbol} ".colorize(background: background)
        end
      end
      puts
    end
  end

  def setup_board
    # Kinged Test Case
    # @grid[6][4] = Piece.new(board: self, color: :white, pos: [6, 4])

    # Sequence Jump Test Case
    # @grid[0][0] = Piece.new(board: self, color: :white, pos: [0, 0])
    # @grid[1][1] = Piece.new(board: self, color: :black, pos: [1, 1])
    # @grid[3][3] = Piece.new(board: self, color: :black, pos: [3, 3])

    #Full Board Setup
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

if $PROGRAM_NAME == "pry"
  board = Board.new
  piece = board.piece_at([0,0])
  piece.perform_moves([[2,2],[4,4]])
end
