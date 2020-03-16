require 'glimmer'
require 'puts_debuggerer'
require 'sounder'

# Glimmer.logger.level = Logger::DEBUG

require_relative 'game_view'

module MathBowling
  class AppView
    include Glimmer

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
          layout GridLayout.new(1,true)
          label(:center) {
            layout_data GridData.new(GSWT[:fill], GSWT[:fill], true, true)
            text "Math Bowling"
            font CONFIG[:title_font]
          }
          composite {
            layout FillLayout.new(SWT::HORIZONTAL)
            layout_data GridData.new(GSWT[:center], GSWT[:center], true, true)
            @focused_widget = button {
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
            layout_data GridData.new(GSWT[:center], GSWT[:center], true, true)
            text "Exit"
            font CONFIG[:font]
            on_widget_selected {
              exit(true)
            }
          }
        }
        @game_type_container.open
      end
      @focused_widget.widget.setFocus
    end
  end
end
