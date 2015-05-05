require 'byebug'
require_relative 'board'
require_relative 'errors'
require_relative 'players/human_player'
require_relative 'players/computer_player'

class Game
  def initialize(board, player1, player2)
    @board = board
    @players = [player1, player2]
  end

  def play
    until @board.won?
      begin
        @board.system_message = "#{@players.first.color}'s Turn!"
        @board.render
        start_pos, sequence = @players.first.make_move
        raise WrongColorPieceError unless right_color_piece?(start_pos)
        @board.move(start_pos, sequence)
        @players.rotate!
      rescue InvalidMoveError => e
        puts e.message
      end
    end

  end
end

def right_color_piece?(pos)
  @board.piece_at(pos).color == @players.first.color
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  player1 = HumanPlayer.new(board, :white)
  player2 = HumanPlayer.new(board, :black)
  game = Game.new(board, player1, player2)
  game.play
end
