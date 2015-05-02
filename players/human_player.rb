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
    sequence = false

    until selected_pos.length == 2
      user_input = read_char
      raise ForceQuitError if user_input == "\u0003"
      current_selected = @board.cursor.dup

      case user_input
      when "\r"
        selected_pos << current_selected
      when "s"
        raise InvalidMoveError if current_selected.nil?
        sequence = true
        selected_pos << Array.new
      else
        @board.move_cursor(user_input)
      end
    end

    if selected_pos[1].empty?
      selected_pos[1] = get_sequence
    end
    selected_pos
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

  def get_sequence
    user_input = ""
    sequence = []

    while true
      user_input = read_char
      raise ForceQuitError if user_input == "\u0003"

      current_selected = @board.cursor.dup
      case user_input
      when "\r"
        sequence << current_selected
      when "e"
        break
      else
        @board.move_cursor(user_input)
      end
    end

    sequence
  end

end
