require_relative 'score_board_view'

class MathBowling
  class GameView
    include Glimmer::UI::CustomShell

    FILE_IMAGE_BACKGROUND = "../../../../images/math-bowling-background.jpg"
    FILE_VIDEOS = {
      'CORRECT' => File.expand_path("../../../../videos/bowling-correct.mp4", __FILE__),
      'WRONG' => File.expand_path("../../../../videos/bowling-wrong.mp4", __FILE__),
      'CLOSE' => File.expand_path("../../../../videos/bowling-close.mp4", __FILE__),
    }
    TIMER_DURATION = 30

    attr_accessor :question_container,
                  :answer_result_announcement, :answer_result_announcement_background,
                  :timer, :roll_button_text
    attr_reader :game, :player_count

    before_body {
      @game = MathBowling::Game.new
      @font = CONFIG[:font].merge(height: 36)
      @font_button = CONFIG[:font].merge(height: 28)
      observe(@game, :roll_done) do |roll_done|
        if roll_done
          if @game.over?
            @restart_button.swt_widget.setFocus
          else
            @initially_focused_widget.swt_widget.setFocus
          end
        end
      end
      observe(@game, :answer_result) do |answer_result|
        @initially_focused_widget.swt_widget.setFocus if answer_result.nil?
      end
    }

    after_body {
      handle_answer_result_announcement
      set_timer
      handle_roll_button_text
      register_video_events
    }

    body {
      shell(:no_resize) {
        @background = :transparent
        @foreground = :black
        text "Math Bowling"
        background_image File.expand_path(FILE_IMAGE_BACKGROUND, __FILE__)
        on_event_show {
          @game.start if @game.not_started?
          show_question
          @initially_focused_widget&.swt_widget.setFocus
        }
        on_event_hide {
          show_question
          @game.quit
        }
        composite {
          composite {
            grid_layout 1, false
            background @background
            Game::PLAYER_COUNT_MAX.times.map { |player_index|
              math_bowling__score_board_view(game: @game, player_index: player_index) {
                layout_data {
                  horizontal_alignment :fill
                  grab_excess_horizontal_space true
                  exclude bind(@game, :player_count) { |player_count| player_index >= player_count.to_i }
                }
              }
            }
          }
          background @background
          composite {
            row_layout {
              type :horizontal
              pack false
              justify true
            }
            layout_data(:fill, :fill, true, true)
            background @background
            @question_container = composite {
              row_layout {
                type :vertical
                fill true
                spacing 6
              }
              background @background
              on_key_pressed {|key_event|
                show_question
              }
              @game_over_announcement_container = composite {
                grid_layout(1, false) {
                  margin_width 0
                  margin_height 15
                  vertical_spacing 0
                }
                layout_data {
                  exclude true
                }
                visible false
                background @background
                label(:center) {
                  background bind(self, :winner_color, computed_by: "game.current_player.index")
                  foreground :white
                  text 'Game Over'
                  font @font.merge(height: 110)
                  layout_data {
                    horizontal_alignment :fill
                    vertical_alignment :center
                    minimum_width 630
                    minimum_height 100
                    grab_excess_horizontal_space true
                  }
                }
                label(:center) {
                  background bind(self, :winner_color, computed_by: "game.current_player.index")
                  foreground :yellow
                  text bind(self, 'game.status', computed_by: ["game.current_player" ,"game.current_player.score_sheet.current_frame"]) {|s| "Winner Score: #{@game.winner_total_score}" }
                  font CONFIG[:scoreboard_font].merge(height: 80)
                  layout_data {
                    horizontal_alignment :fill
                    vertical_alignment :center
                    minimum_width 630
                    minimum_height 100
                    grab_excess_horizontal_space true
                  }
                }
              }
              @videos = MathBowling::Game::ANSWER_RESULTS.reduce({}) do |videos, answer_result|
                videos.merge(
                  answer_result => video(file: FILE_VIDEOS[answer_result], autoplay: false, controls: false, fit_to_height: false, offset_y: -150, offset_x: -80) { |video|
                    layout_data {
                      exclude true
                      width 0
                      height 0
                    }
                    visible false
                    on_mouse_down {
                      show_question
                    }
                    on_ended {
                      show_question
                    }
                    on_playing {
                      video_playing_time = @video_playing_time = Time.now
                      Thread.new {
                        sleep(5)
                        if video_playing_time == @video_playing_time
                          async_exec {
                            show_question
                          }
                        end
                      }
                    }
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
              composite {
                background @background
                grid_layout(1, false) {
                  margin_width 0
                  margin_height 15
                  vertical_spacing 0
                }
                layout_data {
                  exclude false
                }
                label(:center) {
                  background bind(self, :player_color, computed_by: "game.current_player.index")
                  foreground :white
                  text "What is the answer to this math question?"
                  font @font
                  layout_data {
                    horizontal_alignment :fill
                    vertical_alignment :center
                    minimum_width 630
                    minimum_height 100
                    grab_excess_horizontal_space true
                  }
                }
                label(:center) {
                  background bind(self, :player_color, computed_by: "game.current_player.index")
                  foreground :yellow
                  text bind(@game, "question")
                  font @font
                  layout_data {
                    horizontal_alignment :fill
                    vertical_alignment :center
                    minimum_width 630
                    minimum_height 100
                    grab_excess_horizontal_space true
                  }
                }
              }
              @initially_focused_widget = @answer_text = text(:center, :border) {
                focus true
                text bind(@game, "answer")
                font @font
                enabled bind(self, "game.in_progress?", computed_by: ["game.current_player" ,"game.current_player.score_sheet.current_frame"])
                layout_data { exclude false }
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == swt(:cr)
                }
                on_verify_text {|verify_event|
                  final_text = "#{@answer_text.swt_widget.getText}#{verify_event.text}"
                  verify_event.doit = false unless final_text.match(/^[0-9]{0,3}$/)
                }
              }
              button(:center) {
                text bind(self, 'roll_button_text')
                layout_data {
                  height 42
                }
                font @font_button
                background bind(self, :player_color, computed_by: "game.current_player.index")
                foreground :yellow
                enabled bind(self, "game.in_progress?", computed_by: ["game.current_player" ,"game.current_player.score_sheet.current_frame"])
                on_widget_selected {
                  @game.roll
                }
                on_key_pressed {|key_event|
                  @game.roll if key_event.keyCode == swt(:cr)
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
                show_question
              }
            }
            button {
              background CONFIG[:button_background]
              text "Quit Game"
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
            if ENV['DEMO'].to_s.downcase == 'true'
              button {
                background CONFIG[:button_background]
                text "Demo"
                enabled bind(self, "game.in_progress?", computed_by: ["game.current_player" ,"game.current_player.score_sheet.current_frame"])
                font CONFIG[:font]
                on_widget_selected {
                  @game.demo
                }
              }
            end
          }
        }
      }
    }

    def player_count=(value)
      @game.player_count = value
      @player_count = value
    end

    def handle_answer_result_announcement
      observe(@game, :answer_result) do
        if @game.answer_result
          self.answer_result_announcement = "The answer #{@game.answer.to_i} to #{@game.question} was #{@game.answer_result}!"
          self.answer_result_announcement_background = case @game.answer_result
          when 'CORRECT'
            :green
          when 'WRONG'
            :red
          when 'CLOSE'
            :yellow
          end
        else
          self.answer_result_announcement = nil
          self.answer_result_announcement_background = :transparent
        end
      end
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
      observe(@game, :question) do |new_question|
        self.timer = TIMER_DURATION
      end
    end

    def handle_roll_button_text
      observe(self, :timer) do
        roll_text = "Enter Answer (#{self.timer} seconds left)"
        if player_count.to_i > 0 # TODO check if this is truly needed
          roll_text = "Player #{self.game&.current_player&.number} #{roll_text}"
        end
        self.roll_button_text = roll_text
      end
    end

    def register_video_events
      observe(@game, :answer_result) do |new_answer_result|
        show_video if new_answer_result
      end
    end

    def show_video
      new_answer_result = @game.answer_result
      @videos[new_answer_result].play
      @videos[new_answer_result].swt_widget.setLayoutData RowData.new
      @videos[new_answer_result].swt_widget.getLayoutData.width = 600 #344 #@question_container.swt_widget.getSize.x
      @videos[new_answer_result].swt_widget.getLayoutData.height = @question_container.swt_widget.getSize.y
      @question_container.swt_widget.getChildren.each do |child|
        child.getLayoutData.exclude = true
        child.setVisible(false)
      end
      @videos[new_answer_result].swt_widget.getLayoutData.exclude = false
      @videos[new_answer_result].swt_widget.setVisible(true)
      @game_over_announcement_container.swt_widget.getLayoutData&.exclude = true
      @game_over_announcement_container.swt_widget.setVisible(false)
      @question_container.swt_widget.pack
    end

    def show_question
      @video_playing_time = nil
      @videos.values.each(&:reload) #stops playing all videos
      if @game.in_progress?
        @question_container.swt_widget.getChildren.each do |child|
          child.setVisible(true)
          child.getLayoutData&.exclude = false
        end
      end
      @game_over_announcement_container.swt_widget.setVisible(false)
      @game_over_announcement_container.swt_widget.getLayoutData&.exclude = true
      @videos.values.each do |video|
        video.swt_widget.getLayoutData.exclude = true
        video.swt_widget.setVisible(false)
      end
      if @game.not_in_progress?
        @game_over_announcement_container.swt_widget.setVisible(true)
        @game_over_announcement_container.swt_widget.getLayoutData&.exclude = false
      end
      @question_container.swt_widget.pack
      if @game.in_progress?
        @initially_focused_widget.swt_widget.setFocus
        self.timer = TIMER_DURATION
      end
    end

    def player_color
      if @game.current_player.nil?
        CONFIG[:colors][:player1]
      else
        (@game.current_player.index % 2) == 0 ? CONFIG[:colors][:player1] : CONFIG[:colors][:player2]
      end
    end

    def winner_color
      (@game.winner.index % 2) == 0 ? CONFIG[:colors][:player1] : CONFIG[:colors][:player2]
    end

    def show(player_count: 1)
      self.player_count = player_count
      super()
    end

  end
end
