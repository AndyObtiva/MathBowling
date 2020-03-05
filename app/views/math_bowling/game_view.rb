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
              10.times.map do |index|
                composite {
                  layout FillLayout.new(SWT::VERTICAL)
                  composite {
                    layout RowLayout.new
                    label {
                      text bind(@game, "score_sheet.frames[#{index}].roles.first")
                      layout_data RowData.new(10, 20)
                    }
                    label {
                      text bind(@game, "score_sheet.frames[#{index}].roles.last")
                      layout_data RowData.new(10, 20)
                    }
                  }
                  composite {
                    layout RowLayout.new
                    label {
                      text bind(@game, "score_sheet.frames[#{index}].score")
                      layout_data RowData.new(20, 20)
                    }
                  }
                }
              end
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              button {
                text "Start Game"
                enabled bind(@game, :game_not_started, computed_by: [:score_sheet])
                on_widget_selected {
                  @game.start
                }
              }
              button {
                text "Restart Game"
                enabled bind(@game, :game_started, computed_by: [:score_sheet])
                on_widget_selected {
                  @game.restart
                }
              }
              button {
                text "Quit"
                enabled bind(@game, :game_started, computed_by: [:score_sheet])
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
