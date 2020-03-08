require 'glimmer'

require_relative 'frame_view'

module MathBowling
  class ScoreBoardView
    include Glimmer

    include_package 'org.eclipse.swt'
    include_package 'org.eclipse.swt.widgets'
    include_package 'org.eclipse.swt.layout'

    def initialize(game)
      @game = game
    end

    def render
      composite {
        layout FillLayout.new(SWT::VERTICAL)
        @game.player_count.times.map do |player_index|
          composite {
            layout FillLayout.new(SWT::HORIZONTAL)
            10.times.map do |frame_index|
              MathBowling::FrameView.new(@game, player_index, frame_index).render
            end
          }
        end
      }
    end
  end
end
