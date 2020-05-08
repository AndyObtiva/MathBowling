require_relative 'score_board_view'

class MathBowling
  class GameView
    include Glimmer::UI::CustomShell

    FILE_IMAGE_BACKGROUND = "../../../../images/math-bowling-background.jpg"
    TIMER_DURATION = 30

    attr_accessor :question_container,
                  :answer_result_announcement, :answer_result_announcement_background,
                  :timer, :roll_button_text, :video_playing_time
    attr_reader :game, :player_count

    before_body {
      @game = MathBowling::Game.new
      @font = CONFIG[:font].merge(height: 36)
      @font_button = CONFIG[:font].merge(height: 28)
      @answer_result_announcement = "\n" # to take correct multi-line size
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
          body_root.pack
          Thread.new do      
            sleep(0.25)
            async_exec do
              @initially_focused_widget&.swt_widget&.setFocus
            end
          end
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
              score_board_view(game: @game, player_index: player_index) {
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
            grid_layout 1, false
            layout_data(:fill, :fill, true, true)
            background @background
            @question_container = composite {
              layout_data {
                horizontal_alignment :center
                vertical_alignment :center
                grab_excess_horizontal_space true
              }
              row_layout {
                type :vertical
                fill true
                spacing 6
              }
              background @background
              on_key_pressed {|key_event|
                show_next_player unless @showing_next_player
              }
              # Intentionally pre-initializing video widgets for all videos to avoid initial loading time upon playing a video (trading memory for speed)
              @videos_by_answer_result_and_pin_state = VideoRepository.index_by_answer_result_and_pin_state do |answer_result, pin_state|
                VideoRepository.video_paths_by_answer_result_and_pin_state[answer_result][pin_state].map do |video_path|
                  video(file: video_path, autoplay: false, controls: false, fit_to_height: false, offset_x: -80, offset_y: -100) { |video|
                    layout_data {
                      exclude true
                      width 0
                      height 0
                    }
                    visible false
                    on_mouse_down {
                      show_next_player
                    }
                    on_ended {
                      show_next_player
                    }
                    on_playing {
                      video_playing_time = self.video_playing_time = Time.now
                      Thread.new {
                        sleep(5)
                        if video_playing_time == self.video_playing_time
                          async_exec {
                            show_next_player
                          }
                        end
                      }
                    }
                  }                  
                end
              end
              @answer_result_announcement_label = label(:center) {
                background bind(self, 'answer_result_announcement_background')
                text bind(self, 'answer_result_announcement')
                visible bind(@game, 'answer_result')
                font @font.merge height: 22, style: :italic
                layout_data { exclude false }
              }
              label(:center) {
                background CONFIG[:button_background]
                text bind(@game, 'current_player.score_sheet.current_frame.remaining_pins') {|pins| "#{pins} PIN#{'S' if pins != 1} LEFT"}
                font @font.merge height: 36
                layout_data { exclude false }
              }
              @math_question_container = composite {
                background @background
                layout_data { exclude false }
                grid_layout(1, false) {
                  margin_width 0
#                   margin_height 15
                  vertical_spacing 0
                }
                label(:center) {
                  background bind(self, :player_color, computed_by: "game.current_player.index")
                  foreground :yellow
                  text bind(@game, "question") {|question| "#{question} = ?" }
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
              @next_player_announcement_container = composite {
                grid_layout(1, false) {
                  margin_width 0
                  margin_height 0
                  vertical_spacing 10
                }
                layout_data {
                  exclude true
                }
                visible false
                background @background
                label(:center) {
                  background bind(self, :player_color, computed_by: "game.current_player.index")
                  foreground :white
                  text 'NEXT PLAYER'
                  font @font.merge(height: 80)
                  layout_data {
                    horizontal_alignment :fill
                    vertical_alignment :center
                    minimum_width 630
                    minimum_height 100
                    grab_excess_horizontal_space true
                  }
                }
                @continue_button = button(:center) {
                  layout_data {
                    horizontal_alignment :fill
                    grab_excess_horizontal_space true
                    height_hint 42
                  }
                  background bind(self, :player_color, computed_by: "game.current_player.index")
                  foreground :yellow
                  text bind(@game, 'current_player.index') { |i| "Player #{i+1} Continue" }
                  font @font_button
                  on_widget_selected {
                    show_question
                  }
                  on_key_pressed {|key_event|
                    show_question if key_event.keyCode == swt(:cr)
                  }
                }
              }
              @game_over_announcement_container = composite {
                grid_layout(1, false) {
                  margin_width 0
                  margin_height 0
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
                  text 'GAME OVER'
                  font @font.merge(height: 80)
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
            }
          }
          composite {
            fill_layout :horizontal
            layout_data :center, :center, true, true
            background @background
            @restart_button = button {
              background CONFIG[:button_background]
              text "&Restart Game"
              font CONFIG[:font]
              on_widget_selected {
                @game.restart
                show_question
              }
            }
            button {
              background CONFIG[:button_background]
              text "&Back To Main Menu"
              font CONFIG[:font]
              on_widget_selected {
                hide
              }
            }
            button {
              background CONFIG[:button_background]
              text "&Quit"
              font CONFIG[:font]
              on_widget_selected {
                exit(true)
              }
            }
            if ENV['DEMO'].to_s.downcase == 'true'
              button {
                background CONFIG[:button_background]
                text "&Demo"
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
          @last_answer = @game.answer
          new_answer_result_announcement = ''

          if @game.answer_result == 'CLOSE'
            new_answer_result_announcement += "Nice try! "
          elsif @game.answer_result == 'CORRECT'
            if @game.current_player.score_sheet.current_frame.triple_strike?
              new_answer_result_announcement += "Triple Strike! "
            elsif @game.current_player.score_sheet.current_frame.double_strike?
              new_answer_result_announcement += "Double Strike! "
            elsif @game.current_player.score_sheet.current_frame.strike?
              new_answer_result_announcement += "Strike! "
            elsif @game.current_player.score_sheet.current_frame.spare?
              new_answer_result_announcement += "Spare! "
            else
              new_answer_result_announcement += "Great job! "
            end
          end
          remaining_pin_prefix = nil
          if @game.fallen_pins == @game.remaining_pins
            if @game.fallen_pins == 1
              remaining_pin_prefix = 'The'
            else
              remaining_pin_prefix = 'All'
            end
          else
            remaining_pin_prefix = "#{@game.fallen_pins} of"
          end
          new_answer_result_announcement += "#{remaining_pin_prefix} #{@game.remaining_pins}#{' remaining' if @game.remaining_pins < 10} pin#{'s' if @game.remaining_pins != 1} #{@game.fallen_pins != 1 ? 'were' : 'was'} knocked down!"
#           answer_and_correct_answer = [@last_answer.to_i, @game.correct_answer.to_i]
#           fallen_pins_calculation = " Calculation: #{@game.remaining_pins} - (#{answer_and_correct_answer.max} - #{answer_and_correct_answer.min})"
#           new_answer_result_announcement += fallen_pins_calculation

          new_answer_result_announcement += "\n"

          new_answer_result_announcement += "The answer #{@game.answer.to_i} to #{@game.question} was #{@game.answer_result}!"
          if @game.answer_result != 'CORRECT'
            new_answer_result_announcement += " The correct answer is #{@game.correct_answer.to_i}."
          end

          self.answer_result_announcement = new_answer_result_announcement
          self.answer_result_announcement_background = case @game.answer_result
          when 'CORRECT'
            :green
          when 'WRONG'
            :red
          when 'CLOSE'
            :yellow
          end
        else
          self.answer_result_announcement = "\n" # to take correct multi-line size
          self.answer_result_announcement_background = :transparent
        end
      end
    end

    def set_timer
      timer_thread = Thread.new do
        loop do
          sleep(1)
          @game.started? && body_root && async_exec do
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
        if player_count.to_i > 1
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
      new_pin_state = @game.remaining_pins == 10 ? 'full' : 'partial'
      videos = @videos_by_answer_result_and_pin_state[new_answer_result][new_pin_state]
      @video = videos[(rand*videos.size).to_i]
      @video.play
      @video.swt_widget.setLayoutData RowData.new
      @video.swt_widget.getLayoutData.width = @question_container.swt_widget.getSize.x
      @video.swt_widget.getLayoutData.height = @question_container.swt_widget.getSize.y
      @question_container.swt_widget.getChildren.each do |child|
        child.getLayoutData.exclude = true
        child.setVisible(false)
      end
      @video.swt_widget.getLayoutData.exclude = false
      @video.swt_widget.setVisible(true)
      @game_over_announcement_container.swt_widget.getLayoutData&.exclude = true
      @game_over_announcement_container.swt_widget.setVisible(false)
      @question_container.swt_widget.pack
    end

    def all_videos
      @all_videos ||= @videos_by_answer_result_and_pin_state.values.map(&:values).flatten
    end

    def show_next_player
      if @game.in_progress? && (@game.player_count > 1) && (@game.current_player.index != @game.last_player_index)
        self.timer = 86400 # stop timer temporarily by setting to a very high value
        @showing_next_player = true
        @question_container.swt_widget.getChildren.each do |child|
          child.getLayoutData.exclude = true
          child.setVisible(false)
        end
        @answer_result_announcement_label.swt_widget.setVisible(true)
        @answer_result_announcement_label.swt_widget.getLayoutData&.exclude = false
        @next_player_announcement_container.swt_widget.getLayoutData.exclude = false
        @next_player_announcement_container.swt_widget.setVisible(true)
        @question_container.swt_widget.pack
        @continue_button.swt_widget.setFocus
      else
        show_question
      end
    end

    def show_question
      @showing_next_player = false
      self.video_playing_time = nil
      all_videos.each do |video|
        video.pause
        video.position = 0
      end
      if @game.in_progress?
        @question_container.swt_widget.getChildren.each do |child|
          child.setVisible(true)
          child.getLayoutData&.exclude = false
        end        
      end
      @answer_result_announcement_label.swt_widget.setVisible(true)
      @answer_result_announcement_label.swt_widget.getLayoutData&.exclude = false
      @next_player_announcement_container.swt_widget.setVisible(false)
      @next_player_announcement_container.swt_widget.getLayoutData&.exclude = true
      @game_over_announcement_container.swt_widget.setVisible(false)
      @game_over_announcement_container.swt_widget.getLayoutData&.exclude = true
      all_videos.each do |video|
        video.swt_widget&.getLayoutData&.exclude = true
        video.swt_widget&.setVisible(false)
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
