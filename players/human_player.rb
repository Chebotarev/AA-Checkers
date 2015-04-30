class HumanPlayer
  def initialize(board, color)
    @board = board
    @color = color
  end

  def get_move
    print "Enter a start pos > "
    start_pos = gets.chomp.split.map(&:to_i)
    print "Enter an end pos > "
    end_pos = gets.chomp.split.map(&:to_i)
    [start_pos, end_pos]
  end
end
