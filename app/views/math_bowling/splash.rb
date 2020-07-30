require 'glimmer-dsl-swt'
require 'puts_debuggerer'

class MathBowling
  class Splash
    include Glimmer
    
    display # pre-initialize SWT Display before any threads are later created, so they would auto-reuse it

    class << self
      attr_reader :shell_proxy

      def open
        sync_exec {
          @shell_proxy = shell(:no_trim, :on_top) {
            minimum_size 390, 210
            background :transparent
            background_image File.expand_path(File.join('..', '..', '..', '..', 'images', 'math-bowling.gif'), __FILE__)
            cursor display.swt_display.get_system_cursor(swt(:cursor_appstarting))
            grid_layout(1, false)
            label(:center) {
              layout_data :right, :bottom, true, true
              text 'Math Bowling 2'
              background :transparent
              #foreground rgb(138, 31, 41)  
              font height: 16, style: :bold
            }
          }
          @shell_proxy.open
        }
      end

      def close
        sync_exec {
          @shell_proxy&.swt_widget&.close
        }
      end
    end
  end
end
