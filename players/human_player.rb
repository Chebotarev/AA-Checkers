require 'io/console'

class HumanPlayer
  def initialize(board, color)
    @board = board
    @color = color
  end

  def make_move
    # puts "Enter your move"
    # i1, i2 = gets.chomp.split
    # raise BadInputError if i2.nil?

    user_input = ''
    selected_pos = []
    until selected_pos.length == 2
      user_input = read_char
      if user_input == "\r"
        selected_pos << @board.cursor.dup
      else
        @board.move_cursor(user_input)
      end
    end

    selected_pos
    # i1 = @board.move_cursor
    #
    # i2 = @board.move_cursor
    #
    # [i1, i2]
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

end
