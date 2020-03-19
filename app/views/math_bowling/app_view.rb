require 'glimmer'
require 'puts_debuggerer'
require 'sounder'

# Glimmer.logger.level = Logger::DEBUG

require_relative 'game_view'

module MathBowling
  class AppView
    FILE_PATH_IMAGE_MATH_BOWLING = "../../../../images/math-bowling.png"
    include Glimmer

    include_package 'java.lang'

    attr_reader :games

    def initialize
      @display = display.display
      @game_views = (1..2).to_a.map {|n| MathBowling::GameView.new(n, @display) }
      @game_views.each do |game_view|
        Observer.proc do |game_view_visible|
          render unless game_view_visible
        end.observe(game_view, 'game_view_visible')
      end
    end

    def render
      if @game_type_container
        @game_type_container.widget.setVisible(true)
      else
        @game_type_container = shell {
          background CONFIG[:background]
          grid_layout 1, true
          label(:center) {
            layout_data :fill, :fill, true, true
            text "Math Bowling"
            font CONFIG[:title_font]
            foreground CONFIG[:title_foreground]
          }
          composite {
            fill_layout :horizontal
            layout_data :center, :center, true, true
            background :color_transparent
            @initially_focused_widget = button {
              background CONFIG[:background]
              text "1 Player"
              font CONFIG[:font]
              on_widget_selected {
                @game_type_container.widget.setVisible(false)
                @game_views[0].render
              }
            }
            button {
              text "2 Players"
              font CONFIG[:font]
              on_widget_selected {
                @game_type_container.widget.setVisible(false)
                @game_views[1].render
              }
            }
          }
          button {
            layout_data :center, :center, true, true
            text "Exit"
            font CONFIG[:font]
            on_widget_selected {
              exit(true)
            }
          }
          on_paint_control {
            @math_bowling_image.render unless @math_bowling_image.done
          }
        }
        @math_bowling_image = GifImage.new(@game_type_container, File.expand_path(FILE_PATH_IMAGE_MATH_BOWLING, __FILE__), false)
        @game_type_container.open
      end
      @initially_focused_widget.widget.setFocus
    end
  end
end
