require 'glimmer'
require 'puts_debuggerer'
require 'sounder'

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
      @game_views = (1..2).to_a.map {|n| MathBowling::GameView.new(n, @display) }
      @game_views.each do |game_view|
        Observer.proc do |game_view_visible|
          render unless game_view_visible
        end.observe(game_view, 'game_view_visible')
      end
    end

    def render
      if @game_type_container
        @initially_focused_widget.widget.setFocus
        @game_type_container.widget.setVisible(true)
      else
        @game_type_container = shell(:no_resize) {
          grid_layout {
            num_columns 1
            make_columns_equal_width true
            margin_width 35
            margin_height 35
          }
          on_paint_control {
            # Doing on paint control to use calculated shell size
            unless @game_type_container.widget.getBackgroundImage
              image_data = ImageData.new(File.expand_path(FILE_PATH_IMAGE_MATH_BOWLING, __FILE__))
              image_data = image_data.scaledTo(@game_type_container.widget.getSize.x, @game_type_container.widget.getSize.y)
              @splash_image = Image.new(@display, image_data)
              add_contents(@game_type_container) {
                background_image @splash_image
              }
            end
          }
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
              text "1 Player"
              font CONFIG[:font]
              background CONFIG[:button_background]
              on_widget_selected {
                @game_type_container.widget.setVisible(false)
                @game_views[0].render
              }
            }
            button {
              text "2 Players"
              font CONFIG[:font]
              background CONFIG[:button_background]
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
            background CONFIG[:button_background]
            on_widget_selected {
              exit(true)
            }
          }
        }
        @initially_focused_widget.widget.setFocus
        @game_type_container.open
      end
    end
  end
end
