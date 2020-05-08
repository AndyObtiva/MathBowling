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
          Thread.new do
            sleep(0.25)
            async_exec do
              body_root.swt_widget.setActive
              @initially_focused_widget&.swt_widget.setFocus
            end
          end
        }
        on_about {
          display_about_dialog
        }
        on_preferences {
          # No need for preferences. Just display about dialog.
          display_about_dialog
        }
        @game_view = game_view { |game_view|
          game_menu_bar(app_view: self, game_view: game_view)
          on_event_hide {
            body_root.show
          }
        }
        app_menu_bar(app_view: self, game_view: @game_view)
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
              text "&#{n+1} Player#{('s' unless n == 0)}"
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
          text "Quit"
          font CONFIG[:font]
          background CONFIG[:button_background]
          on_widget_selected {
            exit(true)
          }
        }
      }
    }

    def display_about_dialog
      message_box = MessageBox.new(swt_widget)
      message_box.setText("About")
      message = "Math Bowling #{VERSION}\n"
      message += File.read(File.expand_path(File.join('..', '..', '..', '..', 'LICENSE.txt'), __FILE__))
      message_box.setMessage(message)
      message_box.open
    end
  end
end
