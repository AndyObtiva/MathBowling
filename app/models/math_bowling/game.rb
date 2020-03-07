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
      self.score_sheet.frames.each do |frame|
        frame.rolls[0] = (rand*11).to_i
        frame.rolls[1] = (rand*(11 - frame.rolls[0])).to_i
      end
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
