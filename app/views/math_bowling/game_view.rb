require 'glimmer'
require 'puts_debuggerer'
Glimmer.logger.level = Logger::DEBUG

require_relative 'score_board_view'

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
      @game_container = shell {
        text "Math Bowl"
        composite {
          composite {
            layout GridLayout.new(1, false)
            @score_board_container = composite {
              @score_board_view = MathBowling::ScoreBoardView.new(@game).render
            }
            composite {
              layout FillLayout.new(SWT::VERTICAL)
              label {
                text "Pins Remaining:"
              }
              label {
                text bind(@game, "current_player.score_sheet.current_frame.pins_remaining", computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
              }
              label {
                text bind(@game, "question")
              }
              text {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
              }
              button {
                text "Roll"
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                on_widget_selected {
                  @game.roll
                }
              }
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              group {
                layout RowLayout.new(SWT::HORIZONTAL)
                label {
                  text "Game Type:"
                }
                button(:radio) {
                  text "1 Player"
                  enabled bind(@game, :not_in_progress?, computed_by: [:current_player])
                  selection bind(@game, :is_one_player)
                  on_widget_selected {
                    #TODO consider automatic relayout of "glimmer components" or as an option
                    puts ">>1 Player"
                    @score_board_view.widget.dispose
                    add_contents(@score_board_container) {
                      @score_board_view = MathBowling::ScoreBoardView.new(@game).render
                    }
                    @game_container.widget.pack
                  }
                }
                button(:radio) {
                  text "2 Players"
                  enabled bind(@game, :not_in_progress?, computed_by: [:current_player])
                  selection bind(@game, :is_two_players)
                  on_widget_selected {
                    puts ">>2 Players"
                    @score_board_view.widget.dispose
                    add_contents(@score_board_container) {
                      @score_board_view = MathBowling::ScoreBoardView.new(@game).render
                    }
                    @game_container.widget.pack
                  }
                }
              }
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              button {
                text "Start Game"
                enabled bind(@game, :not_in_progress?, computed_by: [:current_player])
                on_widget_selected {
                  @game.start
                }
              }
              button {
                text "Restart Game"
                enabled bind(@game, :in_progress?, computed_by: [:current_player])
                on_widget_selected {
                  @game.restart
                }
              }
              button {
                text "Quit"
                enabled bind(@game, :in_progress?, computed_by: [:current_player])
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
      }
      @game_container.open
    end
  end
end
