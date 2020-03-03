require 'glimmer'
require 'puts_debuggerer'
Glimmer.logger.level = Logger::DEBUG

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
              @game.score_sheet.frames.each_with_index.map do |frame, index|
                composite {
                  layout FillLayout.new(SWT::HORIZONTAL)
                  label {
                    text (frame.roles&.first).to_s
                  }
                  label {
                    text (frame.roles&.last).to_s
                  }
                  label {
                    text (frame.score).to_s
                  }
                }
              end
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              button {
                text "Start Game"
                enabled bind(@game, :game_not_started, computed_by: [:game_started])
                on_widget_selected {
                  @game.start
                }
              }
              button {
                text "Restart Game"
                enabled bind(@game, :game_started)
                on_widget_selected {
                  @game.restart
                }
              }
              button {
                text "Quit"
                enabled bind(@game, :game_started)
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
