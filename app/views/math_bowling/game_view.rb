require 'glimmer'
require 'puts_debuggerer'
require 'sounder'

# Glimmer.logger.level = Logger::DEBUG

require_relative 'score_board_view'

module MathBowling
  class GameView
    include Glimmer

    attr_reader :games

    def initialize
      @games = (1..2).to_a.map {|pc| MathBowling::Game.new(pc) }
      @game_containers = []
      temp_shell = shell
      @display = temp_shell.display
      temp_shell.widget.dispose
      # TODO refactor out into a presenter
      @games.each do |game|
        game.class.class_eval do
          include Glimmer #TODO solve this another way by introducing a presenter
          attr_accessor :display
          def player_color
            @red ||= rgb(138, 31, 41)
            @blue ||= rgb(31, 26, 150)
            if current_player.nil?
              @red
            else
              (current_player.index % 2) == 0 ? @red : @blue
            end
          end
        end
        game.display = @display
      end
      register_sound_effects
    end

    def register_sound_effects
      # Sounder::System.set_volume 70 # 0-100
      @games.each do |game|
        answer_result_sound_observer = BlockObserver.new do |changed_value|
          case changed_value
          when 'CORRECT'
            Sounder.play File.expand_path('../../../../sounds/strike.mp3', __FILE__)
          when 'WRONG'
            Sounder.play File.expand_path('../../../../sounds/bowling.mp3', __FILE__)
          when 'CLOSE'
            Sounder.play File.expand_path('../../../../sounds/spare.mp3', __FILE__)
          end
          sleep(2)
        end
        answer_result_sound_observer.observe(game, :answer_result)
      end
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
              composite {
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
        @game_type_container.open
      end
    end

    def play_game(player_count)
      game_index = player_count - 1
      if @game_containers[game_index]
        @games[game_index].restart
        @game_containers[game_index].widget.setVisible(true)
      else
        @game_containers[game_index] = shell(@display)
        fd = @game_containers[game_index].widget.getFont.getFontData;
        fd[0].setHeight(36);
        @font = Font.new(@display, fd[0]);
        fd[0].setHeight(30);
        @font_button = Font.new(@display, fd[0]);
        add_contents(@game_containers[game_index]) {
          @background = :color_white
          @foreground = :color_black
          text "Math Bowl"
          composite {
            MathBowling::ScoreBoardView.new(@game_containers[game_index], @games[game_index]).render
            composite {
              layout RowLayout.new(SWT::HORIZONTAL).tap {|l| l.pack = false; l.justify = true}
              composite {
                layout FillLayout.new(SWT::VERTICAL)
                background @background
                label(:center) {
                  background @background
                  foreground @foreground
                  text "What is the answer to this math question?"
                  font @font
                }
                label(:center) {
                  background @background
                  foreground @foreground
                  text bind(@games[game_index], "question")
                  font @font
                }
                text(:center, :border) {
                  text bind(@games[game_index], "answer")
                  enabled bind(@games[game_index], :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                  font @font
                }
                button(:center) {
                  text "Roll"
                  font @font_button
                  background bind(@games[game_index], :player_color, computed_by: ["current_player.index"])
                  foreground @background
                  enabled bind(@games[game_index], :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                  on_widget_selected {
                    @games[game_index].roll
                  }
                }
                label(:center) {
                  background @background
                  foreground @foreground
                  text "Your answer was: "
                  visible bind(@games[game_index], 'answer_result')
                  font @font
                }
                label(:center) {
                  background @background
                  foreground @foreground
                  text bind(@games[game_index], 'answer_result')
                  font @font
                }
              }
            }
            composite {
              layout FillLayout.new(SWT::HORIZONTAL)
              button {
                text "Restart Game"
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
        @games[game_index].start
        @game_containers[game_index].open
      end
    end
  end
end
