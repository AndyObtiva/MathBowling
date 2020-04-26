require 'glimmer'

require_relative 'frame_view'

class MathBowling
  class ScoreBoardView
    include Glimmer::UI::CustomWidget

    options :game, :player_index

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
        composite {
          layout_data {
            exclude bind(game, :single_player?, computed_by: :player_count)
          }
          visible bind(game, :single_player?, computed_by: :player_count, on_read: :!)
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
            foreground bind(game, "current_player.index") {|n|
              (game.in_progress? && n == player_index) || (game.not_in_progress? && game.winners.map(&:index).include?(player_index)) ? :yellow : :white
            }
            font CONFIG[:scoreboard_font].merge(height: 80)
          }
        }
        ScoreSheet::COUNT_FRAME.times.map do |frame_index|
          frame_view(game: game, player_index: player_index, frame_index: frame_index)
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
            foreground bind(game, "current_player.index") {|n|
              (game.in_progress? && n == player_index) || (game.not_in_progress? && game.winners.map(&:index).include?(player_index)) ? :yellow : :white
            }
            font CONFIG[:scoreboard_font].merge(height: 80)
          }
        }
      }
    }
  end
end
