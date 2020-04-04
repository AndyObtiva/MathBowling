require_relative 'score_board_view'

module MathBowling
  class GameView
    FILE_IMAGE_BACKGROUND = "../../../../images/math-bowling-background.jpg"
    FILE_VIDEOS = {
      'CORRECT' => File.expand_path("../../../../videos/bowling-correct.mp4", __FILE__),
      'WRONG' => File.expand_path("../../../../videos/bowling-wrong.mp4", __FILE__),
      'CLOSE' => File.expand_path("../../../../videos/bowling-close.mp4", __FILE__),
    }
    TIMER_DURATION = 20

    include Glimmer::SWT::CustomShell

    include_package 'org.eclipse.swt'
    include_package 'org.eclipse.swt.widgets'
    include_package 'org.eclipse.swt.layout'
    include_package 'org.eclipse.swt.graphics'
    include_package 'org.eclipse.swt.browser'
    include_package 'org.eclipse.swt.custom'

    attr_accessor :question_container,
                  :answer_result_announcement, :answer_result_announcement_background,
                  :timer, :roll_button_text
    attr_reader :game

    options :player_count, :display

    before_body do
      @game = MathBowling::Game.new(player_count)
    end

    after_body do
      handle_answer_result_announcement
      set_timer
      handle_roll_button_text
      register_video_events
    end

    def body
      @font = CONFIG[:font].merge(height: 36)
      @font_button = CONFIG[:font].merge(height: 28)
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
      shell(:no_resize) {
        @background = :transparent
        @foreground = :black
        text "Math Bowling"
        background_image File.expand_path(FILE_IMAGE_BACKGROUND, __FILE__)
        on_event_show {
          @game.start
        }
        on_event_hide {
          @game.quit
        }
        composite {
          composite {
            fill_layout :vertical
            background :transparent
            @game.player_count.times.map do |player_index|
              math_bowling__score_board_view(game_container: body_root, game: @game, player_index: player_index)
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
                  answer_result => video(file: FILE_VIDEOS[answer_result], autoplay: false, controls: false, fit_to_height: false, offset_y: -150) {
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
                background bind(self, 'answer_result_announcement_background')
                text bind(self, 'answer_result_announcement')
                visible bind(self, 'game.answer_result')
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
              text "Change Player Count"
              font CONFIG[:font]
              on_widget_selected {
                hide
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
    end

    def handle_answer_result_announcement
      Observer.proc {
        self.answer_result_announcement = "The answer #{@game.answer.to_i} to #{@game.question} was #{@game.answer_result}!"
        self.answer_result_announcement_background = case @game.answer_result
        when 'CORRECT'
          :green
        when 'WRONG'
          :red
        when 'CLOSE'
          :yellow
        end
      }.observe(@game, :answer_result)
    end

    def set_timer
      timer_thread = Thread.new do
        loop do
          sleep(1)
          @game.started? && body_root && body_root.async_exec do
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
        roll_text = "Enter Answer (#{self.timer} seconds left)"
        if @game.player_count > 0
          roll_text = "Player #{self.game&.current_player&.number} #{roll_text}"
        end
        self.roll_button_text = roll_text
      }.observe(self, :timer)
    end

    def register_video_events
      answer_result_sound_observer = Observer.proc do |new_answer_result|
        if new_answer_result
          Thread.new {
            body_root.async_exec do
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
            sleep(5) # fix issue with setting answer result announcement when quitting during video
            body_root.async_exec do
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

  end
end
