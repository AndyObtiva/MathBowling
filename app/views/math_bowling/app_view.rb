# Glimmer.logger.level = Logger::DEBUG

require_relative 'game_view'
require_relative 'app_menu_bar'
require_relative 'game_menu_bar'

class MathBowling
  class AppView
    include Glimmer::UI::CustomShell

    FILE_PATH_IMAGE_MATH_BOWLING = "../../../../images/math-bowling.gif"

    body {
      shell(:no_resize) {
        grid_layout {
          num_columns 1
          make_columns_equal_width true
          margin_width 35
          margin_height 35
        }
        background_image File.expand_path(FILE_PATH_IMAGE_MATH_BOWLING, __FILE__)
        text "Math Bowling"
        on_event_show {
          @initially_focused_widget.swt_widget.setFocus
        }
        @game_view = math_bowling__game_view {
          math_bowling__game_menu_bar(app_view: body_root, game_view: @game_view)
          on_event_hide {
            body_root.show
          }
        }
        math_bowling__app_menu_bar(app_view: body_root, game_view: @game_view)
        label(:center) {
          layout_data :fill, :fill, true, true
          text "Math Bowling"
          font CONFIG[:title_font]
          foreground CONFIG[:title_foreground]
        }
        composite {
          fill_layout :horizontal
          layout_data :center, :center, true, true
          background :transparent
          @buttons = 4.times.map { |n|
            button {
              text "#{n+1} Player#{('s' unless n == 0)}"
              font CONFIG[:font]
              background CONFIG[:button_background]
              on_widget_selected {
                body_root.hide
                @game_view.show(player_count: n+1)
              }
            }
          }
          @initially_focused_widget = @buttons.first
        }
        button {
          layout_data :center, :center, true, true
          text "Exit"
          font CONFIG[:font]
          background CONFIG[:button_background]
          on_widget_selected {
            exit(true)
          }
        }
      }
    }
  end
end
