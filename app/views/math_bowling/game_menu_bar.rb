require_relative 'app_menu_bar'

require 'models/math_bowling/game'

class MathBowling
  class GameMenuBar
    include Glimmer::UI::CustomWidget

    options :app_view, :game_view

    body {
      app_menu_bar(app_view: app_view, game_view: game_view) {
        menu {
          text '&Action'
          menu {
            text "Change &Difficulty"
            Game::DIFFICULTIES.each do |difficulty|
              menu_item(:radio) {
                text difficulty.to_s.titlecase
                selection bind(game_view, 'game.difficulty') {|d| d == difficulty}
                on_widget_selected {
                  game_view.game.difficulty = difficulty
                }
              }              
            end
          }
          menu_item {
            text "Change &Names"
            enabled bind(game_view.game, :player_count) {|pc| pc.to_i > 1}
            on_widget_selected {
              game_view.game.game_current_player = game_view.game.current_player
              game_view.game.current_player = game_view.game.players.first
              game_view.show_name_form
            }
          }
          menu_item {
            text "&Restart Game"
            on_widget_selected {
              game_view.game.restart
              game_view.show_question
            }
          }
          menu_item {
            text "&Back To Main Menu"
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
