require_relative 'score_sheet'

module MathBowling
  class Game
    attr_accessor :score_sheet

    def start
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    def roll
      self.score_sheet.current_frame.roll
    end

    def play
      restart
      self.score_sheet.frames.each {|frame| 3.times {frame.roll}}
    end

    def restart
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    def quit
      self.score_sheet = nil
    end

    # TODO TDD
    def not_started?
      !score_sheet
    end

    # TODO TDD
    def started?
      !not_started?
    end

    # TODO TDD
    def in_progress?
      started? && !score_sheet.game_over?
    end

    # TODO TDD
    def not_in_progress?
      !in_progress?
    end

    # TODO TDD
    def over?
      started? && score_sheet.game_over?
    end
  end
end
