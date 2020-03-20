require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/app_view'

module MathBowling
  extend Glimmer
  DEFAULT = {
    font: {
      name: "Abadi MT Condensed Extra Bold",
      height: 20
    },
    red: rgb(138, 31, 41),
    blue: rgb(31, 26, 150),
  }
  CONFIG = {
    font: DEFAULT[:font],
    scoreboard_font: {
    },
    title_font: DEFAULT[:font].merge(
      height: 60,
    ),
    title_foreground: rgb(138, 31, 41),
    button_background: rgb(245, 245, 220),
  }
  def self.launch
    MathBowling::AppView.new.render
  end
end

MathBowling.launch
