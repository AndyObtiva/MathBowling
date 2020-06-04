# Glimmer.logger.level = Logger::DEBUG

require_relative 'game_view'
require_relative 'player_count_view'
require_relative 'difficulty_view'
require_relative 'math_operation_view'
require_relative 'app_menu_bar'
require_relative 'game_menu_bar'

require 'models/math_bowling/game'
require 'models/math_bowling/game_options'

class MathBowling
  class AppView
    include Glimmer::UI::CustomShell

    FILE_PATH_IMAGE_MATH_BOWLING = "../../../../images/math-bowling.gif"

    before_body {
      @game_options = GameOptions.new
      display {
        on_about {
          display_about_dialog
        }
        on_preferences {
          # No need for preferences. Just display about dialog.
          display_about_dialog
        }
      }
    }

    after_body {
      observe(@game_options, :player_count) do |new_player_count|
        unless new_player_count.nil?
          @player_count_view.body_root.hide
          @difficulty_view.body_root.show
          @math_operation_view.body_root.hide
          @action_container.swt_widget.pack
          @difficulty_view.focus_default_widget
        end
      end
      observe(@game_options, :difficulty) do |new_difficulty|
        unless new_difficulty.nil?
          @player_count_view.body_root.hide
          @difficulty_view.body_root.hide
          @math_operation_view.body_root.show
          @action_container.swt_widget.pack
          @math_operation_view.focus_default_widget
        end
      end
      observe(@game_options, :math_operation) do |new_math_operation|
        unless new_math_operation.nil?
          @player_count_view.body_root.show
          @difficulty_view.body_root.hide
          @math_operation_view.body_root.hide
          @action_container.swt_widget.pack
          @game_view.show(**@game_options.to_h)
        end
      end
    }

    body {
      shell(:no_resize) {
        grid_layout {
          num_columns 1
          make_columns_equal_width true
          margin_width 35
          margin_height 35
        }
        background_image File.expand_path(FILE_PATH_IMAGE_MATH_BOWLING, __FILE__)
        text CONFIG[:game_title]
        on_event_show {
          focus_default_widget
        }
        on_shell_activated {
          focus_default_widget
        }
        @game_view = game_view { |game_view|
          game_menu_bar(app_view: self, game_view: game_view)
          on_event_hide {
            @game_options.reset
            body_root.show
          }
        }
        app_menu_bar(app_view: self, game_view: @game_view)
        label(:center) {
          layout_data :fill, :fill, true, true
          text CONFIG[:game_title]
          font CONFIG[:title_font]
          foreground CONFIG[:title_foreground]
        }
        @action_container = composite {
          grid_layout 1, false
          layout_data :fill, :fill, true, true
          background :transparent
          @player_count_view = player_count_view(game_options: @game_options) {
            layout_data(:center, :center, true, true) {
              exclude false
            }
            background :transparent
          }
          @difficulty_view = difficulty_view(game_options: @game_options) {
            layout_data(:center, :center, true, true) {
              exclude true
              minimum_width 440
            }
            visible false
            background :transparent
          }
          @math_operation_view = math_operation_view(game_options: @game_options) {
            layout_data(:center, :center, true, true) {
              exclude true
              minimum_width 440
            }
            visible false
            background :transparent
          }
        }
        button {
          layout_data :center, :center, true, true
          text "Quit"
          font CONFIG[:font]
          background CONFIG[:button_background]
          visible bind(@game_options, :player_count) {|pc| !pc}
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

    def focus_default_widget
      @player_count_view.focus_default_widget
    end

  end
end
