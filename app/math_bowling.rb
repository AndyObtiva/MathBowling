require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/game_view'

module MathBowling
  def self.launch
    game = MathBowling::Game.new
    game_view = MathBowling::GameView.new(game)
    game_view.render
  end
end

MathBowling.launch
