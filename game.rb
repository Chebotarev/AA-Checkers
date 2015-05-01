require_relative 'board'
require_relative 'errors'
require_relative 'players/human_player'
require_relative 'players/computer_player'

class Game
  def initialize(board, player1, player2)
    @board = board
    @player_white = player1
    @player_black = player2
  end

  def play
    4.times do
      begin
        @board.render
        start_pos, end_pos = @player_white.make_move
        @board.move(start_pos, end_pos)
        @board.render
      rescue InvalidMoveError => e
        puts e.message
      end
    end

  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  player1 = HumanPlayer.new(board, :white)
  player2 = HumanPlayer.new(board, :black)
  game = Game.new(board, player1, player2)
  game.play
end
