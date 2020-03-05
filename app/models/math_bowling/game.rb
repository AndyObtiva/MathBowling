require_relative 'score_sheet'

module MathBowling
  class Game
    attr_accessor :score_sheet

    def initialize
    end

    def start
      self.score_sheet = MathBowling::ScoreSheet.new
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
      !!score_sheet
    end
    #
    # def game_over?
    #   score_sheet&.game_over?
    # end
  end
end
