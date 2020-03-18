require 'sounder'

require_relative 'score_board_view'
require_relative 'gif_image'

module MathBowling
  class GameView
    FILE_PATH_IMAGE_CORRECT = "../../../../images/bowling-strike1.gif"
    FILE_PATH_IMAGE_WRONG = "../../../../images/bowling-miss1.gif"
    FILE_PATH_IMAGE_CLOSE = "../../../../images/bowling-spare1.gif"
    FILE_PATH_SOUND_CORRECT = '../../../../sounds/strike.mp3'
    FILE_PATH_SOUND_WRONG = '../../../../sounds/bowling.mp3'
    FILE_PATH_SOUND_CLOSE = '../../../../sounds/spare.mp3'

    include Glimmer


    attr_accessor :display, :game_view_visible, :question_container
    attr_reader :game, :player_count

    def initialize(player_count, display)
      @player_count = player_count
      @display = display
      @game = MathBowling::Game.new(player_count)
      register_sound_effects
      build_game_container
    end

    def register_sound_effects
      answer_result_sound_observer = Observer.proc do |new_value|
        if new_value
          @question_images ||= {}
          unless @question_images[new_value]
            image_file_path = File.expand_path(self.class.send(:const_get, "FILE_PATH_IMAGE_#{new_value}"), __FILE__)
            @question_images[new_value] = GifImage.new(@question_container, image_file_path)
            Observer.proc {
              @question_container.async_exec do
                @question_container.widget.getChildren.each {|child| child.setVisible(true)}
                @focused_widget.widget.setFocus
              end
            }.observe(@question_images[new_value], 'done')
          end
          @question_container.widget.getChildren.each {|child| child.setVisible(false)}
          @question_images[new_value].render
          @question_container.async_exec do
            sound_file_path = File.expand_path(self.class.send(:const_get, "FILE_PATH_SOUND_#{new_value}"), __FILE__)
            Sounder.play(sound_file_path) rescue nil
          end
        end
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
            @question_container = composite {
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
                visible bind(self, 'question_image.done')
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
