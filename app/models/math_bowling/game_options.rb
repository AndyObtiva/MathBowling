require_relative 'player'

class MathBowling
  class GameOptions
    attr_accessor :player_count, :difficulty, :plus_selected, :minus_selected, :multiply_selected, :divide_selected  
    
    def initialize
      self.plus_selected = true
      self.minus_selected = true
      self.multiply_selected = true
      self.divide_selected = true
    end

    def math_operations
      ops = []
      ops += '+' if plus_selected
      ops += '-' if minus_selected
      ops += '*' if multiply_selected
      ops += '/' if divide_selected
      ops
    end

    def to_h
      {
        player_count: player_count,
        difficulty: difficulty,
      }
    end
  end
end
