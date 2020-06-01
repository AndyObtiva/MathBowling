require 'models/math_bowling/game'

require_relative 'player'

class MathBowling
  class GameOptions
    attr_accessor :player_count, :difficulty, :math_operation

    MATH_OPERATION_ATTRIBUTE_MAPPING = {
      '+'   => :plus_selected,
      '-'   => :minus_selected,
      '*'   => :multiply_selected,
      '/'   => :divide_selected,
      'all' => :all_selected,
    }
    
    def initialize
      reset
    end
    
    def reset      
      self.player_count = nil
      self.difficulty = nil
      self.math_operation = nil
    end

    MATH_OPERATION_ATTRIBUTE_MAPPING.each do |op, attr|
      define_method attr do
        math_operation == op
      end
      define_method "#{attr}=" do |selected|
        self.math_operation = op
      end
    end

    def to_h
      {
        player_count: player_count,
        difficulty: difficulty,
        math_operation: math_operation,
      }
    end
  end
end
