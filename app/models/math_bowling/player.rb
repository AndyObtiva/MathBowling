require_relative 'score_sheet'

module MathBowling
  class Player
    attr_accessor :score_sheet, :index

    def initialize(index)
      self.score_sheet = MathBowling::ScoreSheet.new
      self.index = index
    end
  end
end
