class Piece
  attr_reader :color, :kinged

  def initialize(params)
    @board = params[:board]
    @pos = params[:pos]
    @color = params[:color]
    @kinged = false
  end

  def perform_slide(end_pos)
    if move_diffs.include?(end_pos)
  end

  def perform_jump

  end

  def move_diffs
    if kinged

    else
      modifier = color == :white ? 1 : -1
      [[modifier * 1, 1], [modifier * 1,-1]]
    end
  end

  def symbol
    '☻'
  end
end
