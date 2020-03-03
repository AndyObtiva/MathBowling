require_relative '../math_bowl'
require_relative 'frame'

class MathBowl::ScoreSheet
  def initialize
  end
  def frames
    10.times.map {MathBowl::Frame.new}
  end
  def total_score
    0
  end
  def game_over?
    # frames.all? {|frame| frame.done?}
    false
  end
end
