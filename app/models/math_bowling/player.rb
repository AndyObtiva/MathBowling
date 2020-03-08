require_relative 'score_sheet'

module MathBowling
  class Player
    attr_accessor :score_sheet

    def initialize
      self.score_sheet = MathBowling::ScoreSheet.new
    end
  end
end
