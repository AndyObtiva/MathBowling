require 'glimmer'
require 'puts_debuggerer'
# Glimmer.logger.level = Logger::DEBUG

require_relative 'score_board_view'

module MathBowling
  class GameView
    include Glimmer

    def initialize(game)
      @game = game
      @game_container = shell
      @display = @game_container.display
      request_game_type
    end

    def request_game_type
      add_contents(@game_type_container = shell(@display)) {
        composite {
          layout FillLayout.new(SWT::HORIZONTAL)
          group {
            layout RowLayout.new(SWT::HORIZONTAL)
            composite {
              label {
                text "Game Type:"
              }
            }
            composite {
              button(:radio) {
                text "1 Player"
                selection bind(@game, :is_one_player)
                on_widget_selected {
                  @game_type_container.widget.dispose
                  play_game
                }
              }
            }
            composite {
              button(:radio) {
                text "2 Players"
                selection bind(@game, :is_two_players)
                on_widget_selected {
                  @game_type_container.widget.dispose
                  play_game
                }
              }
            }
          }
        }
      }
      @game_type_container.open
    end

    def play_game
      add_contents(@game_container = shell(@display)) {
        text "Math Bowl"
        composite {
          composite {
            layout GridLayout.new(1, false)
            MathBowling::ScoreBoardView.new(@game_container, @game).render
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
                text "Switch To #{(@game.player_count % 2) + 1}-Player Game"
                on_widget_selected {
                  @game_container.widget.dispose
                  request_game_type
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
