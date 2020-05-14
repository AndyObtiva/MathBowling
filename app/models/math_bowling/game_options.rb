require 'models/math_bowling/game'

require_relative 'player'

class MathBowling
  class GameOptions
    attr_accessor :player_count, :difficulty, :math_operations

    MATH_OPERATION_ATTRIBUTE_MAPPING = {
      'all' => :all_selected,
      '+'   => :plus_selected,
      '-'   => :minus_selected,
      '*'   => :multiply_selected,
      '/'   => :divide_selected,
    }
    
    def initialize
      self.plus_selected = true
      self.minus_selected = true
      self.multiply_selected = true
      self.divide_selected = true
    end

    MATH_OPERATION_ATTRIBUTE_MAPPING.reject {|op, attr| op == 'all' }.each do |op, attr|
      define_method attr do
        @math_operations.to_a.include?(op)
      end
      define_method "#{attr}=" do |selected|
        self.math_operations = self.math_operations.to_a + [op] if selected && !send(attr)
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
