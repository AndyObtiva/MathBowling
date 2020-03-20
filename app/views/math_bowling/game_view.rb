require 'sounder'

require_relative 'score_board_view'
require_relative 'gif_image'

module MathBowling
  class GameView
    FILE_PATH_IMAGE_BACKGROUND = "../../../../images/math-bowling-background.jpg"
    FILE_PATH_IMAGE_CORRECT = "../../../../images/bowling-strike1.gif"
    FILE_PATH_IMAGE_WRONG = "../../../../images/bowling-miss1.gif"
    FILE_PATH_IMAGE_CLOSE = "../../../../images/bowling-spare1.gif"
    FILE_PATH_SOUND_CORRECT = '../../../../sounds/strike.mp3'
    FILE_PATH_SOUND_WRONG = '../../../../sounds/bowling.mp3'
    FILE_PATH_SOUND_CLOSE = '../../../../sounds/spare.mp3'
    TIMER_DURATION = 20

    include Glimmer


    attr_accessor :display, :game_view_visible, :question_container, :answer_result_announcement, :timer, :roll_button_text
    attr_reader :game, :player_count

    def initialize(player_count, display)
      @player_count = player_count
      @display = display
      @game = MathBowling::Game.new(player_count)
      handle_answer_result_announcement
      set_timer
      handle_roll_button_text
      register_sound_effects
      build_game_container
    end

    def handle_answer_result_announcement
      Observer.proc {
        self.answer_result_announcement = "The answer #{@game.answer.to_i} to #{@game.question} was #{@game.answer_result}!"
      }.observe(@game, :answer_result)
    end

    def set_timer
      timer_thread = Thread.new do
        loop do
          sleep(1)
          @game.started? && @game_container && @game_container.async_exec do
            self.timer = self.timer - 1 if self.timer && self.timer > 0
            if self.timer == 0
              @game.roll
            end
          end
        end
      end
      Observer.proc {
        self.timer = TIMER_DURATION
      }.observe(@game, :question)
    end

    def handle_roll_button_text
      Observer.proc {
        self.roll_button_text = "Enter Answer (#{self.timer} seconds left)"
      }.observe(self, :timer)
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
                @initially_focused_widget.widget.setFocus
                self.timer = TIMER_DURATION
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
      @font_button = CONFIG[:font].merge(height: 28)
      @game_container = shell(:no_resize) {
        @background = :transparent
        @foreground = :black
        text "Math Bowling"

        on_paint_control {
          # Doing on paint control to use calculated shell size
          unless @game_container.widget.getBackgroundImage
            image_data = ImageData.new(File.expand_path(FILE_PATH_IMAGE_BACKGROUND, __FILE__))
            image_data = image_data.scaledTo(@game_container.widget.getSize.x, @game_container.widget.getSize.y)
            @background_image = Image.new(@display, image_data)
            add_contents(@game_container) {
              background_image @background_image
            }
          end
        }

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
              row_layout {
                type :vertical
                fill true
                spacing 6
              }
              background @background
              label(:center) {
                background @background
                text bind(self, 'answer_result_announcement')
                visible bind(self, 'question_image.done')
                font @font.merge height: 22, style: :italic
              }
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
              @initially_focused_widget = text(:center, :border) {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                font @font
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == GSWT[:cr]
                }
              }
              on_paint_control {
                @game.start if @game.not_started?
              }
              button(:center) {
                text bind(self, 'roll_button_text')
                layout_data {
                  height 42
                }
                font @font_button
                background bind(self, :player_color, computed_by: "game.current_player.index")
                foreground :yellow
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                on_widget_selected {
                  @game.roll
                }
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == GSWT[:cr]
                }
              }
            }
          }
          composite {
            fill_layout :horizontal
            layout_data :center, :center, true, true
            background @background
            @restart_button = button {
              background CONFIG[:button_background]
              text "Restart Game"
              font CONFIG[:font]
              on_widget_selected {
                @game.restart
              }
            }
            button {
              background CONFIG[:button_background]
              text "Change Players"
              font CONFIG[:font]
              on_widget_selected {
                @game_container.widget.setVisible(false)
                @game.quit
                self.game_view_visible = false
              }
            }
            button {
              background CONFIG[:button_background]
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
            @initially_focused_widget.widget.setFocus
          end
        end
      end.observe(@game, :roll_done)
      Observer.proc do |answer_result|
        @initially_focused_widget.widget.setFocus if answer_result.nil?
      end.observe(@game, :answer_result)
    end

    def render
      if @game_container_opened
        @game.restart unless @game.not_started?
        @game_container.widget.setVisible(true)
        self.game_view_visible = true
      else
        @game.start
        self.game_view_visible = true
        @game_container_opened = true
        @game_container.open
      end
      @initially_focused_widget.widget.setFocus
    end
  end
end
