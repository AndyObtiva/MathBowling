require 'glimmer'
require 'puts_debuggerer'
Glimmer.logger.level = Logger::DEBUG

require_relative 'frame_view'

module MathBowling
  class GameView
    include Glimmer

    include_package 'org.eclipse.swt'
    include_package 'org.eclipse.swt.widgets'
    include_package 'org.eclipse.swt.layout'

    def initialize(game)
      @game = game
    end

    def render
      shell {
        text "Math Bowl"
        composite {
          composite {
            layout GridLayout.new(1, false)
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              10.times.map do |index|
                MathBowling::FrameView.new(@game, index).render
              end
            }
            composite {
              layout FillLayout.new(SWT::VERTICAL)
              label {
                text "Pins Remaining:"
              }
              label {
                text bind(@game, "score_sheet.current_frame.pins_remaining", computed_by: 10.times.map {|index| "score_sheet.frames[#{index}].rolls"})
              }
              label {
                text bind(@game, "question")
              }
              text {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: ['score_sheet'] + 10.times.map {|index| "score_sheet.frames[#{index}].rolls"})
              }
              button {
                text "Roll"
                enabled bind(@game, :in_progress?, computed_by: ['score_sheet'] + 10.times.map {|index| "score_sheet.frames[#{index}].rolls"})
                on_widget_selected {
                  @game.roll
                }
              }
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              button {
                text "Start Game"
                enabled bind(@game, :not_in_progress?, computed_by: [:score_sheet])
                on_widget_selected {
                  @game.start
                }
              }
              button {
                text "Restart Game"
                enabled bind(@game, :in_progress?, computed_by: [:score_sheet])
                on_widget_selected {
                  @game.restart
                }
              }
              button {
                text "Quit"
                enabled bind(@game, :in_progress?, computed_by: [:score_sheet])
                on_widget_selected {
                  @game.quit
                }
              }
              button {
                text "Exit"
                on_widget_selected {
                  exit(true)
                }
              }
            }
          }
        }
      }.open
    end
  end
end
