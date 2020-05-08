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
#         on_event_show {
#           @player_count = nil
#           @difficulty = nil
#           @player_count_view.swt_widget.setVisible true
#           @player_count_view.swt_widget.layoutData.exclude = false
#         }
        on_shell_activated {
          @initially_focused_widget.swt_widget.setFocus
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
        @action_container = composite {
          grid_layout 1, false
          layout_data :fill, :fill, true, true
          background :transparent
          @player_count_view = composite {
            fill_layout :horizontal
            layout_data(:center, :center, true, true) {
              exclude false
            }
            background :transparent
            @player_count_buttons = 4.times.map { |n|
              button {
                text "&#{n+1} Player#{('s' unless n == 0)}"
                font CONFIG[:font]
                background CONFIG[:button_background]
                on_widget_selected {
                  @player_count = n+1
                  @player_count_view.swt_widget.layoutData.exclude = true
                  @player_count_view.swt_widget.setVisible false
                  @difficulty_view.swt_widget.layoutData.exclude = false
                  @difficulty_view.swt_widget.setVisible true
                  @action_container.swt_widget.pack
                  @difficulty_buttons.first.swt_widget.setFocus # see if you can do on show of button instead
                }
              }
            }
            @initially_focused_widget = @player_count_buttons.first
          }
          @difficulty_view = composite {
            fill_layout :horizontal
            layout_data(:fill, :fill, true, true) {
              exclude true
            }
            visible false
            background :transparent
            @difficulty_buttons = %i[easy medium hard].map { |difficulty|
              button {
                text difficulty.to_s.titlecase
                font CONFIG[:font]
                background CONFIG[:button_background]
                on_widget_selected {
                  @difficulty = difficulty
                  @difficulty_view.swt_widget.layoutData.exclude = true
                  @difficulty_view.swt_widget.setVisible false
                  @player_count_view.swt_widget.layoutData.exclude = false
                  @player_count_view.swt_widget.setVisible true
                  @action_container.swt_widget.pack
                  @game_view.show(player_count: @player_count, difficulty: @difficulty)
                }
              }
            }
          }
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
