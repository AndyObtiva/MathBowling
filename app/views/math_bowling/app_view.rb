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
      temp_shell = shell
      @display = temp_shell.display
      temp_shell.widget.dispose
      @game_views = (1..2).to_a.map {|n| MathBowling::GameView.new(n, @display) }
      @game_views.each do |game_view|
        # add_contents(game_view.game_container) do
        #   on_paint_control do |paint_event|
        #
        #   end
        # end

        BlockObserver.new do |game_view_visible|
          render unless game_view_visible
        end.observe(game_view, 'game_view_visible')
      end
    end

    def render
      if @game_type_container
        @game_type_container.widget.setVisible(true)
      else
        add_contents(@game_type_container = shell(@display)) {
          composite {
            layout FillLayout.new(SWT::HORIZONTAL)
            group {
              layout RowLayout.new(SWT::HORIZONTAL)
              composite {
                label {
                  text "Game Type:"
                }
              }
              composite {
                button {
                  text "1 Player"
                  on_widget_selected {
                    @game_type_container.widget.setVisible(false)
                    @game_views[0].render
                  }
                }
              }
              composite {
                button {
                  text "2 Players"
                  on_widget_selected {
                    @game_type_container.widget.setVisible(false)
                    @game_views[1].render
                  }
                }
              }
              composite {
                button {
                  text "Exit"
                  on_widget_selected {
                    exit(true)
                  }
                }
              }
            }
          }
        }
        @game_type_container.open
      end
    end
  end
end
