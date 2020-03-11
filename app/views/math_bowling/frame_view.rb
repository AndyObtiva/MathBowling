require 'glimmer'

module MathBowling
  class FrameView
    SIZE_ROLL_SCORE = [40, 40]
    SIZE_RUNNING_SCORE = [80, 40]
    include Glimmer

    def initialize(game_container, game, player_index, frame_index)
      @game_container = game_container
      @game = game
      @display = @game_container.display
      @player_index = player_index
      @frame_index = frame_index
      @red = Color.new(@display, 138, 31, 41)
      @blue = Color.new(@display, 31, 26, 150)
      @background = player_index % 2 == 0 ? @red : @blue
      @white = Color.new(@display, 255, 255, 255)

      fd = @game_container.widget.getFont.getFontData;
      fd[0].setHeight(36);
      @font = Font.new(@display, fd[0]);
    end

    def render
      composite(:border) {
        layout RowLayout.new(SWT::VERTICAL)
        background @background
        composite {
          layout RowLayout.new(SWT::HORIZONTAL)
          background @background
          label {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[0]")
            layout_data RowData.new(*SIZE_ROLL_SCORE)
            background @background
            foreground @white
            font @font
          }
          label(:border) {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[1]")
            layout_data RowData.new(*SIZE_ROLL_SCORE)
            background @background
            foreground @white
            font @font
          }
          if (@frame_index + 1) == 10
            label {
              text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
              layout_data RowData.new(*SIZE_ROLL_SCORE)
              background @background
              foreground @white
              visible bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
              font @font
            }
          end
        }
        composite {
          layout RowLayout.new(SWT::HORIZONTAL).tap {|l| l.pack = false; l.justify = true}
          background @background
          label {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].running_score", computed_by: 10.times.map {|index| "players[#{@player_index}].score_sheet.frames[#{index}].rolls"})
            layout_data RowData.new(*SIZE_RUNNING_SCORE)
            background @background
            foreground @white
            font @font
          }
        }
      }
    end
  end
end
