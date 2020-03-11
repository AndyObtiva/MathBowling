require 'glimmer'

module MathBowling
  class FrameView
    include Glimmer

    def initialize(game, display, player_index, frame_index)
      @game = game
      @display = display
      @player_index = player_index
      @frame_index = frame_index
      @red = Color.new(@display, 138, 31, 41)
      @blue = Color.new(@display, 31, 26, 150)
      @background = player_index % 2 == 0 ? @red : @blue
      @white = Color.new(@display, 255, 255, 255)
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
            layout_data RowData.new(20, 20)
            background @background
            foreground @white
          }
          label {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[1]")
            layout_data RowData.new(20, 20)
            background @background
            foreground @white
          }
          label {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
            layout_data RowData.new(20, 20)
            background @background
            foreground @white
            visible bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].rolls[2]")
          }
        }
        composite {
          layout RowLayout.new(SWT::HORIZONTAL)
          background @background
          label {
            text bind(@game, "players[#{@player_index}].score_sheet.frames[#{@frame_index}].running_score", computed_by: 10.times.map {|index| "players[#{@player_index}].score_sheet.frames[#{index}].rolls"})
            layout_data RowData.new(20, 20)
            background @background
            foreground @white
          }
        }
      }
    end
  end
end
