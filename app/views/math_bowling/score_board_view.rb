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
        layout FillLayout.new(SWT::VERTICAL)
        @game.player_count.times.map do |player_index|
          composite {
            layout RowLayout.new(SWT::HORIZONTAL)
            ScoreSheet::COUNT_FRAME.times.map do |frame_index|
              MathBowling::FrameView.new(@game_container, @game, player_index, frame_index).render
            end
            @red = rgb(138, 31, 41)
            @blue = rgb(31, 26, 150)
            @background = player_index % 2 == 0 ? @red : @blue
            @foreground = rgb(255, 255, 0)
            composite(:border) {
              layout RowLayout.new(SWT::HORIZONTAL)
              background @background
              label(:center) {
                text bind(@game, "players[#{player_index}].score_sheet.total_score", computed_by: 10.times.map {|index| "players[#{player_index}].score_sheet.frames[#{index}].rolls"})
                layout_data RowData.new(135, 95)
                background @background
                foreground @foreground
                font height: 70
              }
            }
          }
        end
      }
    end
  end
end
