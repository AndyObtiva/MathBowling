require 'models/math_bowling/game'

require_relative 'player'

class MathBowling
  class GameOptions
    attr_accessor :player_count, :difficulty, :math_operations

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
      self.math_operations = []      
    end

    MATH_OPERATION_ATTRIBUTE_MAPPING.reject {|op, attr| op == 'all' }.each do |op, attr|
      define_method attr do
        @math_operations.to_a.include?(op)
      end
      define_method "#{attr}=" do |selected|
        if selected && !send(attr)
          self.math_operations << op
        end
      end
    end

    def all_selected
      math_operations.sort == Game::MATH_OPERATIONS.sort
    end

    def all_selected=(selected)
      self.math_operations = Game::MATH_OPERATIONS if selected
    end

    def to_h
      {
        player_count: player_count,
        difficulty: difficulty,
        math_operations: math_operations,
      }
    end
  end
end
