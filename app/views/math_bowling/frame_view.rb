require 'glimmer'

module MathBowling
  class FrameView
    include Glimmer

    include_package 'org.eclipse.swt'
    include_package 'org.eclipse.swt.widgets'
    include_package 'org.eclipse.swt.layout'

    def initialize(game, frame_index)
      @game = game
      @frame_index = frame_index
    end

    def render
      composite {
        layout FillLayout.new(SWT::VERTICAL)
        composite {
          layout RowLayout.new
          label {
            text bind(@game, "score_sheet.frames[#{@frame_index}].rolls[0]")
            layout_data RowData.new(10, 20)
          }
          label {
            text bind(@game, "score_sheet.frames[#{@frame_index}].rolls[1]")
            layout_data RowData.new(10, 20)
          }
          label {
            text bind(@game, "score_sheet.frames[#{@frame_index}].rolls[2]")
            layout_data RowData.new(10, 20)
          }
        }
        composite {
          layout RowLayout.new
          label {
            text bind(@game, "score_sheet.frames[#{@frame_index}].running_score", computed_by: 10.times.map {|index| "score_sheet.frames[#{@frame_index}].rolls"})
            layout_data RowData.new(20, 20)
          }
        }
      }
    end
  end
end
