require 'models/math_bowling/game_options'

require_relative 'excludable_composite'

class MathBowling
  class PlayerCountView
    include Glimmer::UI::CustomWidget

    options :game_options

    after_body {
      @initially_focused_widget = @player_count_buttons.first
    }

    body {
      excludable_composite {
        fill_layout(:horizontal) {
          spacing 15
        }
        background :transparent
        @player_count_buttons = 4.times.map { |n|
          button {
            text "&#{n+1} Player#{('s' unless n == 0)}"
            font CONFIG[:font]
            background CONFIG[:button_background]
            on_widget_selected {
              game_options.player_count = n+1
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
