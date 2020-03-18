require 'sounder'

require_relative 'score_board_view'

module MathBowling
  class GameView
    include Glimmer

    attr_accessor :display, :game_view_visible
    attr_reader :game, :player_count

    def initialize(player_count, display)
      @player_count = player_count
      @display = display
      @game = MathBowling::Game.new(player_count)
      register_sound_effects
      build_game_container
    end

    def register_sound_effects
      answer_result_sound_observer = Observer.proc do |changed_value|
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
      answer_result_sound_observer.observe(@game, :answer_result)
    end

    def player_color
      @red ||= rgb(138, 31, 41)
      @blue ||= rgb(31, 26, 150)
      if @game.current_player.nil?
        @red
      else
        (@game.current_player.index % 2) == 0 ? @red : @blue
      end
    end

    def build_game_container
      @font = CONFIG[:font].merge(height: 36)
      @font_button = CONFIG[:font].merge(height: 30)
      @game_container = shell {
        @background = :color_white
        @foreground = :color_black
        text "Math Bowling"
        composite {
          MathBowling::ScoreBoardView.new(@game_container, @game).render
          background @background
          composite {
            row_layout {
              type :horizontal
              pack false
              justify true
            }
            layout_data GridData.new(GSWT[:fill], GSWT[:fill], true, true)
            background @background
            composite {
              fill_layout :vertical
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
                text bind(@game, "question")
                font @font
              }
              @focused_widget = text(:center, :border) {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                font @font
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == GSWT[:cr]
                }
              }
              button(:center) {
                text "Roll"
                font @font_button
                background bind(self, :player_color, computed_by: ["game.current_player.index"])
                foreground @background
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                on_widget_selected {
                  @game.roll
                }
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == GSWT[:cr]
                }
              }
              label(:center) {
                background @background
                foreground @foreground
                text "Your answer was: "
                visible bind(@game, 'answer_result')
                font @font
              }
              label(:center) {
                background @background
                foreground @foreground
                text bind(@game, 'answer_result')
                font @font
              }
            }
          }
          composite {
            fill_layout :horizontal
            layout_data :center, :center, true, true
            background @background
            @restart_button = button {
              background @background
              text "Restart Game"
              font CONFIG[:font]
              on_widget_selected {
                @game.restart
              }
            }
            button {
              background @background
              text "Change Players"
              font CONFIG[:font]
              on_widget_selected {
                @game_container.widget.setVisible(false)
                self.game_view_visible = false
              }
            }
            button {
              background @background
              text "Exit"
              font CONFIG[:font]
              on_widget_selected {
                exit(true)
              }
            }
          }
        }
      }
      Observer.proc do |roll_done|
        if roll_done
          if @game.over?
            @restart_button.widget.setFocus
          else
            @focused_widget.widget.setFocus
          end
        end
      end.observe(@game, :roll_done)
      Observer.proc do |answer_result|
        @focused_widget.widget.setFocus if answer_result.nil?
      end.observe(@game, :answer_result)
    end

    def render
      if @game_container_opened
        @game.restart if @game.not_started?
        @game_container.widget.setVisible(true)
        self.game_view_visible = true
      else
        @game.start
        self.game_view_visible = true
        @game_container_opened = true
        @game_container.open
      end
      @focused_widget.widget.setFocus
    end
  end
end
