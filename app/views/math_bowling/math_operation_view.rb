require 'models/math_bowling/game_options'
require 'models/math_bowling/game'

require_relative 'excludable_composite'

class MathBowling
  class MathOperationView
    include Glimmer::UI::CustomWidget

    options :game_options

    after_body {
      @initially_focused_widget = @math_operation_buttons.first
    }

    body {
      excludable_composite {
        grid_layout 4, true
        background :transparent
        @math_operation_buttons = GameOptions::MATH_OPERATION_ATTRIBUTE_MAPPING.map { |math_operation, attribute|
          button {
            layout_data(:center, :center, true, true) {
              width_hint math_operation == 'all' ? 200 : 50
              horizontal_span math_operation == 'all' ? 4 : 1
            }
            text (Game::MATH_OPERATION_TRANSLATION[math_operation]).titlecase
            font CONFIG[:font]
            background CONFIG[:button_background]
            on_widget_selected {
              game_options.send("#{attribute}=", true)
            }
          }
        }
      }
    }

    def focus_default_widget
      Thread.new do      
        sleep(0.25)
        async_exec do
          @initially_focused_widget.swt_widget.setFocus
        end
      end
    end
  end
end
