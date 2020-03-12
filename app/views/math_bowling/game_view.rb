require 'glimmer'
require 'puts_debuggerer'
# Glimmer.logger.level = Logger::DEBUG

require_relative 'score_board_view'

module MathBowling
  class GameView
    include Glimmer

    def initialize
      @games = (1..2).to_a.map {|pc| MathBowling::Game.new(pc) }
      @game_containers = []
      temp_shell = shell
      @display = temp_shell.display
      temp_shell.widget.dispose
    end

    def render
      request_game_type
    end

    def request_game_type
      if @game_type_container
        @game_type_container.widget.setVisible(true)
      else
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
                button {
                  text "1 Player"
                  on_widget_selected {
                    @game_type_container.widget.setVisible(false)
                    play_game(1)
                  }
                }
              }
              composite {
                button {
                  text "2 Players"
                  on_widget_selected {
                    @game_type_container.widget.setVisible(false)
                    play_game(2)
                  }
                }
              }
            }
          }
        }
        @game_type_container.open
      end
    end

    def play_game(player_count)
      game_index = player_count - 1
      if @game_containers[game_index]
        @game_containers[game_index].widget.setVisible(true)
      else
        add_contents(@game_containers[game_index] = shell(@display)) {
          text "Math Bowl"
          composite {
            composite {
              layout GridLayout.new(1, false)
              MathBowling::ScoreBoardView.new(@game_containers[game_index], @games[game_index]).render
              composite {
                layout FillLayout.new(SWT::VERTICAL)
                label {
                  text "Pins Remaining:"
                }
                label {
                  text bind(@games[game_index], "current_player.score_sheet.current_frame.pins_remaining", computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                }
                label {
                  text bind(@games[game_index], "question")
                }
                text {
                  text bind(@games[game_index], "answer")
                  enabled bind(@games[game_index], :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                }
                button {
                  text "Roll"
                  enabled bind(@games[game_index], :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                  on_widget_selected {
                    @games[game_index].roll
                  }
                }
              }
              composite {
                layout FillLayout.new(SWT::HORIZONTAL)
                button {
                  text "Start Game"
                  enabled bind(@games[game_index], :not_in_progress?, computed_by: [:current_player])
                  on_widget_selected {
                    @games[game_index].start
                  }
                }
                button {
                  text "Restart Game"
                  enabled bind(@games[game_index], :in_progress?, computed_by: [:current_player])
                  on_widget_selected {
                    @games[game_index].restart
                  }
                }
                button {
                  text "Change Players"
                  on_widget_selected {
                    @game_containers[game_index].widget.setVisible(false)
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
        @game_containers[game_index].open
      end
    end
  end
end
