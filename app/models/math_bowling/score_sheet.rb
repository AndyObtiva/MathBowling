require_relative 'frame'

module MathBowling
  class ScoreSheet
    def initialize
    end
    def frames
      10.times.map {MathBowling::Frame.new}
    end
    def total_score
      0
    end
    def game_over?
      # frames.all? {|frame| frame.done?}
      false
    end
  end
end
