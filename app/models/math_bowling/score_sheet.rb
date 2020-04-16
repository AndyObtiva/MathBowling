require_relative 'frame'

module MathBowling
  class ScoreSheet
    COUNT_FRAME = 10
    attr_accessor :frames, :current_frame
    def initialize
      @frames = COUNT_FRAME.times.map {|index| MathBowling::Frame.new(index + 1)}
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
      self.current_frame = @frames.first
    end
    def switch_to_next_frame
      self.current_frame = frames[(frames.index(current_frame) + 1)] if current_frame
    end
    def total_score
      frames.map(&:score).map(&:to_i).sum
    end
    def game_over?
      current_frame.nil?
    end
  end
end
