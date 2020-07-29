require 'bundler'
Bundler.require

require 'facets'

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
    answer_result_announcement_font: {
      height: 22,
      style: :italic
    },
    button_font: { height: 28 },
    scoreboard_name_font: {
      height: 26
    },
    frame_font: { height: 36 },
    scoreboard_total_font: {
      height: 80
    },
    title_font: DEFAULT[:font].merge(
      height: 60,
    ),
    title_foreground: rgb(138, 31, 41),
    game_title: 'Math Bowling 2',
    button_background: rgb(245, 245, 220),
    label_button_minimum_height: 100,
  }


  if OS.windows?
    DEFAULT[:font][:height] = 14 
    CONFIG[:font][:height] = 14 
    CONFIG[:answer_result_announcement_font][:height] = 14 
    CONFIG[:button_font][:height] = 20 
    CONFIG[:scoreboard_name_font][:height] = 18 
    CONFIG[:frame_font][:height] = 22 
    CONFIG[:scoreboard_total_font][:height] = 54 
    CONFIG[:label_button_minimum_height] = 100 
  end

  def launch
    app_view.open
  end
end
