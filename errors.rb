class InvalidMoveError < ArgumentError
end

class NoPieceError < InvalidMoveError
end

class WrongColorPieceError < InvalidMoveError
end

class ForceQuitError < StandardError
end
