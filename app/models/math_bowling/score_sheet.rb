require_relative 'frame'

module MathBowling
  class ScoreSheet
    attr_accessor :frames
    def initialize
      @frames = 10.times.map {MathBowling::Frame.new}
    end
    def total_score
      frames.map(&:score).map(&:to_i).sum
    end
    def game_over?
      # frames.all? {|frame| frame.done?}
      false
    end
  end
end
