require_relative '../math_bowl'
require_relative 'score_sheet'

class MathBowl::Game
  def score_sheet
    MathBowl::ScoreSheet.new    
  end
end
