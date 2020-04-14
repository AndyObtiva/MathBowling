require 'glimmer'

module MathBowling
  class FrameView
    SIZE_ROLL_SCORE = [50, 50]
    SIZE_RUNNING_SCORE = [100, 50]
    SIZE_RUNNING_SCORE_FINAL = [150, 50]

    include Glimmer::UI::CustomWidget

    options :game, :player_index, :frame_index

    body {
      @background = player_index % 2 == 0 ? CONFIG[:colors][:player1] : CONFIG[:colors][:player2]
      @foreground = :white
      @font = CONFIG[:scoreboard_font].merge(height: 36)
      composite {
        row_layout {
          type :vertical
          margin_left 0
          margin_right 0
          margin_top 0
          margin_bottom 0
          spacing 0
        }
        background @background
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
            text bind(game, "players[#{player_index}].score_sheet.frames[#{frame_index}].rolls[0]")
            layout_data *SIZE_ROLL_SCORE
            background @background
            foreground @foreground
            font @font
          }
          label(:center) {
            text bind(game, "players[#{player_index}].score_sheet.frames[#{frame_index}].rolls[1]")
            layout_data *SIZE_ROLL_SCORE
            background @background
            foreground @foreground
            font @font
          }
          if (frame_index + 1) == 10
            label(:center) {
              text bind(game, "players[#{player_index}].score_sheet.frames[#{frame_index}].rolls[2]")
              layout_data *SIZE_ROLL_SCORE
              background @background
              foreground @foreground
              visible bind(game, "players[#{player_index}].score_sheet.frames[#{frame_index}].rolls[2]")
              font @font
            }
          end
        }
        composite {
          row_layout {
            type :horizontal
            pack false
            justify true
            margin_left 0
            margin_right 0
            margin_top 0
            margin_bottom 0
            spacing 0
          }
          background @background
          label(:center) {
            text bind(game, "players[#{player_index}].score_sheet.frames[#{frame_index}].running_score", computed_by: 10.times.map {|index| "players[#{player_index}].score_sheet.frames[#{index}].rolls"})
            layout_data *((frame_index + 1 == 10) ? SIZE_RUNNING_SCORE_FINAL : SIZE_RUNNING_SCORE)
            background @background
            foreground @foreground
            font @font
          }
        }
      }
    }
  end
end
