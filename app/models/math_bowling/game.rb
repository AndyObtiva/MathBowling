require_relative 'score_sheet'

module MathBowling
  class Game
    attr_accessor :score_sheet
    attr_accessor :game_started

    def initialize
      self.game_started = false
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    def start
      self.game_started = true
    end

    def restart
      self.score_sheet = MathBowling::ScoreSheet.new
    end

    def quit
      initialize
    end

    def game_not_started
      !game_started
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
