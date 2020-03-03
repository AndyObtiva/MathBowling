require_relative 'models/math_bowl/game'
require_relative 'views/math_bowl/game_view'

game = MathBowl::Game.new

game_view = MathBowl::GameView.new(game)
