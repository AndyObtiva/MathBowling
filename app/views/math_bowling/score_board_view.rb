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
          }
        end
      }
    end
  end
end
