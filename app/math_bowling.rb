require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/game_view'

module MathBowling
  def self.launch
    MathBowling::GameView.new.render
  end
end

MathBowling.launch
