require 'glimmer'

require_relative 'frame_view'

module MathBowling
  class ScoreBoardView
    include Glimmer

    def initialize(game, display)
      @game = game
      @display = display
    end

    def render
      composite {
        layout FillLayout.new(SWT::VERTICAL)
        @game.player_count.times.map do |player_index|
          composite {
            layout FillLayout.new(SWT::HORIZONTAL)
            10.times.map do |frame_index|
              MathBowling::FrameView.new(@game, @display, player_index, frame_index).render
            end
          }
        end
      }
    end
  end
end
