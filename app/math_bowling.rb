require 'glimmer'
require 'glimmer-cw-video'
require 'puts_debuggerer'
require 'to_collection'
require 'array_include_methods'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require_relative 'models/math_bowling/game'
require_relative 'models/math_bowling/video_repository'
require_relative 'views/math_bowling/app_view'

class MathBowling
  include Glimmer

  display.swt_display.loadFont(File.expand_path('../../fonts/AbadiMTCondensedExtraBold.ttf', __FILE__))

  APP_ROOT = File.expand_path(File.join('..', '..'), __FILE__)

  VERSION = File.read(File.expand_path('../../VERSION',__FILE__))

  DEFAULT = {
    font: {
      name: 'Abadi MT Condensed Extra Bold',
      height: 20,
    },
    red: rgb(128, 0, 0),
    charcoal: rgb(54	,69	,79),
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
    game_title: 'Math Bowling 2',
    button_background: rgb(245, 245, 220),
  }

  def launch
    app_view.open
  end
end
