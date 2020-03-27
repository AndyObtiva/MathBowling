require_relative 'score_board_view'
require_relative 'gif_image'
require_relative 'video'

module MathBowling
  class GameView
    FILE_IMAGE_BACKGROUND = "../../../../images/math-bowling-background.jpg"
    FILE_VIDEOS = {
      'CORRECT' => File.expand_path("../../../../videos/bowling-correct.mp4", __FILE__),
      'WRONG' => File.expand_path("../../../../videos/bowling-wrong.mp4", __FILE__),
      'CLOSE' => File.expand_path("../../../../videos/bowling-close.mp4", __FILE__),
    }
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
      register_video_events
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

    def register_video_events
      answer_result_sound_observer = Observer.proc do |new_answer_result|
        if new_answer_result
          Thread.new {
            @game_container.async_exec do
              @videos[new_answer_result].play
              @videos[new_answer_result].widget.setLayoutData RowData.new
              @videos[new_answer_result].widget.getLayoutData.width = 600 #344 #@question_container.widget.getSize.x
              @videos[new_answer_result].widget.getLayoutData.height = @question_container.widget.getSize.y
              @question_container.widget.getChildren.each do |child|
                child.getLayoutData.exclude = true
                child.setVisible(false)
              end
              @videos[new_answer_result].widget.getLayoutData.exclude = false
              @videos[new_answer_result].widget.setVisible(true)
              @question_container.widget.pack
            end
            sleep(5)
            @game_container.async_exec do
              @question_container.widget.getChildren.each do |child|
                child.setVisible(true)
                child.getLayoutData&.exclude = false
              end
              @videos.values.each do |video|
                video.widget.getLayoutData.exclude = true
                # video.widget.getLayoutData.width = 0
                # video.widget.getLayoutData.height = 0
                video.widget.setVisible(false)
              end
              @question_container.widget.pack
              @initially_focused_widget.widget.setFocus
              self.timer = TIMER_DURATION
            end
          }
        end
      end
      answer_result_sound_observer.observe(@game, :answer_result)
    end

    def player_color
      if @game.current_player.nil?
        CONFIG[:colors][:player1]
      else
        (@game.current_player.index % 2) == 0 ? CONFIG[:colors][:player1] : CONFIG[:colors][:player2]
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
            image_data = ImageData.new(File.expand_path(FILE_IMAGE_BACKGROUND, __FILE__))
            image_data = image_data.scaledTo(@game_container.widget.getSize.x, @game_container.widget.getSize.y)
            @background_image = Image.new(@display, image_data)
            add_contents(@game_container) {
              background_image @background_image
            }
          end
        }

        composite {
          composite {
            fill_layout :vertical
            background :transparent
            @game.player_count.times.map do |player_index|
              math_bowling__score_board_view(game_container: @game_container, game: @game, player_index: player_index)
            end
          }
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
              @videos = MathBowling::Game::ANSWER_RESULTS.reduce({}) do |videos, answer_result|
                videos.merge(
                  answer_result => video(file: FILE_VIDEOS[answer_result]) {
                    layout_data {
                      exclude true
                      width 0
                      height 0
                    }
                    visible false
                  }
                )
              end
              label(:center) {
                background (@game.player_count == 1 ? :yellow : @background) # TODO figure this out
                text bind(self, 'answer_result_announcement')
                visible bind(self, 'question_image.done')
                font @font.merge height: 22, style: :italic
                layout_data { exclude false }
              }
              label(:center) {
                background @background
                foreground @foreground
                text "What is the answer to this math question?"
                font @font
                layout_data { exclude false }
              }
              label(:center) {
                background @background
                foreground @foreground
                text bind(@game, "question")
                font @font
                layout_data { exclude false }
              }
              @initially_focused_widget = text(:center, :border) {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                font @font
                layout_data { exclude false }
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
