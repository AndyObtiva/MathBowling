require_relative 'app_menu_bar'

class MathBowling
  class GameMenuBar
    include Glimmer::UI::CustomWidget

    options :app_view, :game_view

    body {
      math_bowling__app_menu_bar(app_view: app_view, game_view: game_view) {
        menu {
          text '&Action'
          menu_item {
            text "&Restart"
            on_widget_selected {
              game_view.game.restart
              game_view.show_question
            }
          }
          menu_item {
            text "&Quit"
            on_widget_selected {
              game_view.hide
            }
          }
          if ENV['DEMO'].to_s.downcase == 'true'
            menu_item {
              text "&Demo"
              on_widget_selected {
                game_view.game.demo
              }
            }
          end
        }
      }
    }
  end
end
