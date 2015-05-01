class InvalidMoveError < ArgumentError
end

class NoPieceError < InvalidMoveError

end

class ForceQuitError < StandardError
end
