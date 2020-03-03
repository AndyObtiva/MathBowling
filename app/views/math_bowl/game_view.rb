require_relative '../math_bowl'
require 'glimmer'
require 'puts_debuggerer'
Glimmer.logger.level = Logger::DEBUG
class MathBowl::GameView
  include Glimmer

  include_package 'org.eclipse.swt'
  include_package 'org.eclipse.swt.widgets'
  include_package 'org.eclipse.swt.layout'

  def initialize(game)
    @game = game
    render
  end

  def render
    shell {
      text "Math Bowl"
      composite {
        composite {
          layout GridLayout.new(1, false)
          composite {
            # bind_collection(@game, "score_sheet.frames") do |frame, index|
            #   composite {
            #     label {
            #       text (frame.roles&.first).to_s
            #     }
            #     label {
            #       text (frame.roles&.last).to_s
            #     }
            #     label {
            #       text (frame.score).to_s
            #     }
            #   }
            # end
          }
          button {
            text "Start Game"
            enabled bind(@game, :game_not_started, computed_by: [:score_sheet])
            on_widget_selected {
              @game.start
            }
          }
          button {
            text "Quit"
            on_widget_selected {
              exit(true)
            }
          }
        }
      }
    }.open
  end
end
