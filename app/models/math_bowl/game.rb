require_relative '../math_bowl'
require_relative 'score_sheet'

class MathBowl::Game
  attr_accessor :score_sheet

  def start
    self.score_sheet = MathBowl::ScoreSheet.new
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
