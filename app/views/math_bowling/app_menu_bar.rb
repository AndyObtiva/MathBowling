require_relative 'game_rules_dialog'

require 'models/math_bowling/game'

class MathBowling
  class AppMenuBar
    include Glimmer::UI::CustomWidget

    options :app_view, :game_view

    body {
      menu_bar {
        menu {
          text '&Game'
          menu {
            text "Start &Game"
            4.times.map { |n|
              menu {
                text "&#{n+1} Player#{('s' unless n == 0)}"
                Game::DIFFICULTIES.each { |difficulty|
                  menu {
                    text difficulty.to_s.titlecase                    
                    Game::MATH_OPERATION_TRANSLATION.each { |math_operation, math_operation_translation|
                      menu_item {
                        text math_operation_translation.titlecase
                        on_widget_selected {
                          app_view.hide
                          game_view.hide
                          game_view.show(player_count: n+1, difficulty: difficulty, math_operations: math_operation)
                        }
                      }                    
                    }
                  }
                }
              }
            }
          }
          menu_item(:separator)
          menu_item {
            text "&Quit"
            on_widget_selected {
              exit(true)
            }
          }
        }
        content&.call
        menu {
          text '&Help'
          menu_item {
            text "Game &Rules"
            on_widget_selected {
              game_rules_dialog.open
            }
          }
        }
      }
    }
  end
end
