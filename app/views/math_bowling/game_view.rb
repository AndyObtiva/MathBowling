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
      build_game_container
    end

    def register_sound_effects
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
      @game_container = shell(@display)
      @font = {height: 36}
      @font_button = {height: 30}
      add_contents(@game_container) {
        @background = :color_white
        @foreground = :color_black
        text "Math Bowl"
        composite {
          MathBowling::ScoreBoardView.new(@game_container, @game).render
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
                text bind(@game, "question")
                font @font
              }
              text(:center, :border) {
                text bind(@game, "answer")
                enabled bind(@game, :in_progress?, computed_by: 10.times.map {|index| "current_player.score_sheet.frames[#{index}].rolls"})
                font @font
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
            layout FillLayout.new(SWT::HORIZONTAL)
            button {
              text "Restart Game"
              on_widget_selected {
                @game.restart
              }
            }
            button {
              text "Change Players"
              on_widget_selected {
                @game_container.widget.setVisible(false)
                self.game_view_visible = false
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
    end

    def render
      if @game_container_opened
        @game.restart
        @game_container.widget.setVisible(true)
        self.game_view_visible = true
      else
        @game.start
        self.game_view_visible = true
        @game_container_opened = true
        @game_container.open
      end
    end
  end
end
