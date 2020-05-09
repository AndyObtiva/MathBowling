require_relative 'score_sheet'

class MathBowling
  class Player
    attr_accessor :score_sheet, :index, :name

    def initialize(index)
      self.index = index
      reset
    end

    def number
      index + 1
    end

    def reset
      self.score_sheet = MathBowling::ScoreSheet.new
    end
  end
end
