class MathBowling
  class AppMenuBar
    include Glimmer::UI::CustomWidget

    options :app_view, :game_view

    body {
      menu_bar {
        menu {
          text '&Game'
          4.times.map { |n|
            menu_item {
              text "&#{n+1} Player#{('s' unless n == 0)}"
              on_widget_selected {
                app_view.hide
                game_view.show(player_count: n+1)
              }
            }
          }
          menu_item {
            text "E&xit"
            on_widget_selected {
              exit(true)
            }
          }
        }
        content&.call
      }
    }
  end
end
