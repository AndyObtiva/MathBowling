require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/app_view'

module MathBowling
  DEFAULT = {
    font: {
      name: "Abadi MT Condensed Extra Bold",
      height: 18
    }
  }
  CONFIG = {
    font: DEFAULT[:font],
    scoreboard_font: {
    },
    title_font: DEFAULT[:font].merge(
      height: 60,
    ),
  }
  def self.launch
    MathBowling::AppView.new.render
  end
end

MathBowling.launch
