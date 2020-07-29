require 'models/math_bowling/game_options'

require_relative 'excludable_composite'

class MathBowling
  class DifficultyView
    include Glimmer::UI::CustomWidget

    BUTTON_HORIZONTAL_ALIGNMENT = {
      easy: :right,
      medium: :center,
      hard: :left
    }

    options :game_options

    after_body {
      @initially_focused_widget = @difficulty_buttons.first
    }

    body {
      excludable_composite {
        grid_layout 3, true
        background :transparent
        @difficulty_buttons = Game::DIFFICULTIES.map { |difficulty|
          button {
            layout_data(BUTTON_HORIZONTAL_ALIGNMENT[difficulty], :center, true, true) {
              minimum_width 113.33
            }
            text difficulty.to_s.titlecase
            font CONFIG[:font]
            background CONFIG[:button_background]
            on_widget_selected {
              game_options.difficulty = difficulty
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
