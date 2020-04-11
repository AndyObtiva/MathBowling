require 'glimmer'

require_relative 'frame_view'

module MathBowling
  class ScoreBoardView
    include Glimmer::UI::CustomWidget

    options :game_container, :game, :player_index

    body {
      @background = player_index % 2 == 0 ? CONFIG[:colors][:player1] : CONFIG[:colors][:player2]
      composite {
        row_layout {
          type :horizontal
          margin_left 3
          margin_right 3
          margin_top 3
          margin_bottom 3
          spacing 3
        }
        if game.player_count > 1
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
              text bind(game, "players[#{player_index}].number")
              layout_data 100, 100
              background @background
              foreground :white
              font CONFIG[:scoreboard_font].merge(height: 80)
            }
          }
        end
        ScoreSheet::COUNT_FRAME.times.map do |frame_index|
          # MathBowling::FrameView.new(game_container, game, player_index, frame_index).render
          math_bowling__frame_view(game_container: game_container, game: game, player_index: player_index, frame_index: frame_index)
        end
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
            text bind(game, "players[#{player_index}].score_sheet.total_score", computed_by: 10.times.map {|index| "players[#{player_index}].score_sheet.frames[#{index}].rolls"})
            layout_data 150, 100
            background @background
            foreground :yellow
            font CONFIG[:scoreboard_font].merge(height: 80)
          }
        }
      }
    }
  end
end
