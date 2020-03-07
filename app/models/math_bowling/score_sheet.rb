require_relative 'frame'

module MathBowling
  class ScoreSheet
    attr_accessor :frames
    def initialize
      @frames = 10.times.map {|index| MathBowling::Frame.new(index + 1)}
      next_frames = @frames.rotate(1)
      next_frames.last = nil
      @frames.zip(next_frames).each do |frame, next_frame|
        frame.next_frame = next_frame
      end
      previous_frames = @frames.rotate(-1)
      previous_frames.first = nil
      @frames.zip(previous_frames).each do |frame, previous_frame|
        frame.previous_frame = previous_frame
      end
    end
    def current_frame
      @frames.detect {|frame| !frame.done?}
    end
    def total_score
      frames.map(&:score).map(&:to_i).sum
    end
    def game_over?
      current_frame.nil?
    end
  end
end
