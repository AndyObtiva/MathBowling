require_relative 'score_sheet'

module MathBowling
  class Game
    attr_accessor :score_sheet

    def start
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    # TODO implement restart

    def quit
      self.score_sheet = nil
    end

    def game_not_started
      !score_sheet
    end

    # TODO TDD
    # def game_started?
    #   !!score_sheet
    # end
    #
    # def game_over?
    #   score_sheet&.game_over?
    # end
  end
end
