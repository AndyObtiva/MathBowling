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
        frame.roles[0] = (rand*11).to_i
        frame.roles[1] = (rand*(11 - frame.roles[0])).to_i
      end
    end

    def restart
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    def quit
      self.score_sheet = nil
    end

    def game_not_started
      !game_started
    end

    # TODO TDD
    def game_started
      !!(score_sheet && !score_sheet.game_over?)
    end
    #
    # def game_over?
    #   score_sheet&.game_over?
    # end
  end
end
