require 'glimmer'

require_relative 'models/math_bowling/game'
require_relative 'views/math_bowling/app_view'

module MathBowling
  extend Glimmer
  DEFAULT = {
    font: {
      name: "Abadi MT Condensed Extra Bold",
      height: 20,
      # style: :bold
    },
    # red: rgb(138, 31, 41),
    # light_red: rgb(148, 95, 100),
    red: rgb(128, 0, 0),
    # blue: rgb(31, 26, 150),
    # brown: rgb(186, 153, 72)
    # brown: rgb(213, 199, 155),
    charcoal: rgb(83	,74	,64),
  }
  CONFIG = {
    colors: {
      player1: DEFAULT[:red],
      player2: DEFAULT[:charcoal],
    },
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
