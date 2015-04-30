require 'byebug'

class Piece
  UP_MOVES = [
    [1, 1],
    [1, -1]
  ]

  DOWN_MOVES = [
    [-1, 1],
    [-1, -1]
  ]

  UP_ATTACKS = [
    [2, 2],
    [2, -2]
  ]

  DOWN_ATTACKS = [
    [-2, 2],
    [-2, -2]
  ]

  attr_reader :color, :kinged

  def initialize(params)
    @board = params[:board]
    @pos = params[:pos]
    @color = params[:color]
    @kinged = false
  end

  def perform_slide(end_pos)
    # debugger

    if slides.include?(end_pos)
      move_to!(end_pos)
      return true
    end

    false
  end

  def perform_jump(end_pos)
    if jumps.include?(end_pos) && @board.piece_at(jumped_piece_pos(end_pos))
      @board[jumped_piece_pos(end_pos)] = nil
      move_to!(end_pos)
      return true
    end

    false
  end

  def moves
    moves = move_diffs.map.with_index do |move_diff, i|
      move_diff.map.with_index do |deltas, j|
        deltas + @pos[j]
      end
    end

    moves.select { |move| @board.on_board?(move) }
  end

  def jumps
    moves.select { |move| (move.first - @pos.first).abs == 2 }
  end

  def slides
    moves.select { |move| (move.first - @pos.first).abs == 1 }
  end

  def move_diffs
    if @kinged
      UP_MOVES + DOWN_MOVES + UP_ATTACKS + DOWN_ATTACKS
    else
      color == :white ? UP_MOVES + UP_ATTACKS : DOWN_MOVES + DOWN_ATTACKS
    end
  end

  def move_to!(pos)
    @board[@pos] = nil
    @board[pos] = self
    @pos = pos
    maybe_promote
  end

  def jumped_piece_pos(end_pos)
    end_pos.map.with_index do |end_coord, i|
      (end_coord + @pos[i]) / 2
    end
  end

  def maybe_promote
    @kinged = true if @pos.first == 0 || @pos.first == 7
  end

  def symbol
    '☻'
  end
end
