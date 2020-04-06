require 'glimmer'
require 'puts_debuggerer'

# Glimmer.logger.level = Logger::DEBUG

require_relative 'game_view'

module MathBowling
  class AppView
    FILE_PATH_IMAGE_MATH_BOWLING = "../../../../images/math-bowling.gif"
    include Glimmer

    include_package 'java.lang'

    attr_reader :games

    def initialize
      @display = display.display
      @game_views = (1..4).to_a.map {|n| math_bowling__game_view(player_count: n, display: @display) }
      @game_views.each do |game_view|
        game_view.on_event_hide do
          render
        end
      end
    end

    def render
      if @game_type_container
        @initially_focused_widget.widget.setFocus
        @game_type_container.show
      else
        @game_type_container = shell(:no_resize) {
          grid_layout {
            num_columns 1
            make_columns_equal_width true
            margin_width 35
            margin_height 35
          }
          background_image File.expand_path(FILE_PATH_IMAGE_MATH_BOWLING, __FILE__)
          label(:center) {
            layout_data :fill, :fill, true, true
            text "Math Bowling"
            font CONFIG[:title_font]
            foreground CONFIG[:title_foreground]
          }
          composite {
            fill_layout :horizontal
            layout_data :center, :center, true, true
            background :transparent
            @buttons = 4.times.map do |n|
              button {
                text "#{n+1} Player#{('s' unless n == 0)}"
                font CONFIG[:font]
                background CONFIG[:button_background]
                on_widget_selected {
                  @game_type_container.hide
                  @game_views[n].show
                }
              }
            end
            @initially_focused_widget = @buttons.first
          }
          button {
            layout_data :center, :center, true, true
            text "Exit"
            font CONFIG[:font]
            background CONFIG[:button_background]
            on_widget_selected {
              exit(true)
            }
          }
        }
        @initially_focused_widget.widget.setFocus
        @game_type_container.show
      end
    end
  end
end
