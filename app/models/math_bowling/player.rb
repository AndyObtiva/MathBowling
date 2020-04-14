require_relative 'score_sheet'

module MathBowling
  class Player
    attr_accessor :score_sheet, :index

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
