require 'glimmer-dsl-swt'
require 'puts_debuggerer'

class MathBowling
  class Splash
    include Glimmer

    class << self
      attr_reader :shell_proxy

      def open
        sync_exec {
          @shell_proxy = shell(:no_trim, :on_top) {
            minimum_size 390, 210
            background :transparent
            background_image File.expand_path(File.join('..', '..', 'images', 'math-bowling.gif'), __FILE__)
            cursor display.swt_display.get_system_cursor(swt(:cursor_appstarting))
            grid_layout(1, false)
            label(:center) {
              layout_data :right, :bottom, true, true
              text 'Math Bowling 2'
              background :transparent
              #foreground rgb(138, 31, 41)  
              font height: 16, style: :bold
            }
          }
          @shell_proxy.open
        }
      end

      def close
        sync_exec {
          @shell_proxy&.swt_widget&.close
        }
      end
    end
  end

end

Thread.new do
  MathBowling::Splash.open
end

require 'bundler'
Bundler.require

require 'facets'
require 'fileutils'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require_relative 'models/math_bowling/game'
require_relative 'models/math_bowling/video_repository'
require_relative 'views/math_bowling/app_view'

class MathBowling
  include Glimmer

  sync_exec {
    # Extracting font file first from packaged JAR file since SWT can only read extracted files
    font_file = File.expand_path('../../fonts/AbadiMTCondensedExtraBold.ttf', __FILE__)
    font_file_binary_content = File.binread(font_file)
    FileUtils.mkdir_p('fonts') 
    extracted_font_file = 'fonts/AbadiMTCondensedExtraBold.ttf'
    File.binwrite(extracted_font_file, font_file_binary_content)
    display.swt_display.loadFont(extracted_font_file)
  }

  APP_ROOT = File.expand_path(File.join('..', '..'), __FILE__)
  APP_ICON = File.join(APP_ROOT, 'package', 'windows', 'Math Bowling 2.ico')

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
    sync_exec {
      @app_view = app_view
      Splash.close
      @app_view.open
    }
  end
end
