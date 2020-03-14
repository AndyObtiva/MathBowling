require 'glimmer'

module MathBowling
  class FrameView
    SIZE_ROLL_SCORE = [40, 40]
    SIZE_RUNNING_SCORE = [80, 40]
    SIZE_RUNNING_SCORE_FINAL = [120, 40]
    include Glimmer

    def initialize(game_container, game, player_index, frame_index)
      @game_container = game_container
      @game = game
      @display = @game_container.display
      @player_index = player_index
      @frame_index = frame_index
      @red = rgb(138, 31, 41)
      @blue = rgb(31, 26, 150)
      @background = player_index % 2 == 0 ? @red : @blue
      @foreground = rgb(255, 255, 255)
      @font = {height: 36}
    end

    def render
      composite(:border) {
        layout RowLayout.new(SWT::VERTICAL)
        background @background
        composite {
          layout RowLayout.new(SWT::HORIZONTAL)
          background @background
          label(:center) {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[0]")
            layout_data RowData.new(*SIZE_ROLL_SCORE)
            background @background
            foreground @foreground
            font @font
          }
          label(:center) {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[1]")
            layout_data RowData.new(*SIZE_ROLL_SCORE)
            background @background
            foreground @foreground
            font @font
          }
          if (@frame_index + 1) == 10
            label(:center) {
              text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
              layout_data RowData.new(*SIZE_ROLL_SCORE)
              background @background
              foreground @foreground
              visible bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
              font @font
            }
          end
        }
        composite {
          layout RowLayout.new(SWT::HORIZONTAL).tap {|l| l.pack = false; l.justify = true}
          background @background
          label(:center) {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].running_score", computed_by: 10.times.map {|index| "players[#{@player_index}].score_sheet.frames[#{index}].rolls"})
            layout_data RowData.new(*((@frame_index + 1 == 10) ? SIZE_RUNNING_SCORE_FINAL : SIZE_RUNNING_SCORE))
            background @background
            foreground @foreground
            font @font
          }
        }
      }
    end
  end
end
