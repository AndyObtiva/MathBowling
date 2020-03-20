require 'glimmer'

require_relative 'frame_view'

module MathBowling
  class ScoreBoardView
    include Glimmer

    attr_reader :content

    def initialize(game_container, game)
      @game = game
      @game_container = game_container
    end

    def render
      @content = composite {
        fill_layout :vertical
        background :transparent
        @game.player_count.times.map do |player_index|
          composite {
            row_layout {
              type :horizontal
              margin_left 3
              margin_right 3
              margin_top 3
              margin_bottom 3
              spacing 3
            }
            ScoreSheet::COUNT_FRAME.times.map do |frame_index|
              MathBowling::FrameView.new(@game_container, @game, player_index, frame_index).render
            end
            @red = rgb(138, 31, 41)
            @blue = rgb(31, 26, 150)
            @background = player_index % 2 == 0 ? @red : @blue
            @foreground = :yellow
            composite {
              row_layout {
                type :horizontal
                margin_left 0
                margin_right 0
                margin_top 0
                margin_bottom 0
                spacing 0
              }
              background @background
              label(:center) {
                text bind(@game, "players[#{player_index}].score_sheet.total_score", computed_by: 10.times.map {|index| "players[#{player_index}].score_sheet.frames[#{index}].rolls"})
                layout_data RowData.new(150, 100)
                background @background
                foreground @foreground
                font CONFIG[:scoreboard_font].merge(height: 80)
              }
            }
          }
        end
      }
    end
  end
end
