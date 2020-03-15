require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/app_view'

module MathBowling
  def self.launch
    MathBowling::AppView.new.render
  end
end

MathBowling.launch
