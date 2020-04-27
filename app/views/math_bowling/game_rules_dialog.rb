class MathBowling
  class GameRulesDialog
    include Glimmer::UI::CustomShell

    body {
      shell(:dialog_trim, :application_modal) {
        text 'Game Rules'
        minimum_size 1000, 750
        browser {
          text File.read(File.join(APP_ROOT, 'docs', 'game_rules.html'))
        }
      }
    }
  end
end
