require 'glimmer'

class GifImage
  include Glimmer

  include_package 'java.lang'
  include_package 'java.io'

  attr_accessor :done

  def initialize(parent, image_path)
    self.done = false
    @parent = parent
    @loader = ImageLoader.new
    resource = FileInputStream.new(image_path)
    @loader.load(resource)
    @display = @parent.display
    @image = Image.new(@display, 1, 1);
    add_contents(@parent) {
      on_paint_control { |paint_event|
        paint_event.gc.drawImage(@image, 0, 0)
      }
    }
  end
  def render
    @imageNumber = 0
    @image.dispose
    @image = Image.new(@display, @loader.data[0])
    @parent.async_exec {
      @parent.widget.redraw()
    }
    java.lang.Thread.new(
      GRunnable.new {
        while true
          currentTime = System.currentTimeMillis
          delayTime = @loader.data[@imageNumber].delayTime
          while (currentTime + delayTime * 10 > System.currentTimeMillis)
            # Wait till the delay time has passed
          end
          if @imageNumber == @loader.data.length - 1
            self.done = false
            @image.dispose
            @image = Image.new(@display, 1, 1);
            @parent.async_exec {
              @parent.widget.redraw()
            }
            @imageNumber = 0
            break
          else
            @parent.async_exec {
              # Increase the variable holding the frame number
              @imageNumber = (@imageNumber+1)#%@loader.data.length
              # Draw the new data onto the @image
              nextFrameData = @loader.data[@imageNumber]
              frameImage = Image.new(@display, nextFrameData);
              @gc = org.eclipse.swt.graphics.GC.new(@image);
              @gc.drawImage(frameImage, nextFrameData.x, nextFrameData.y)
              @parent.widget.redraw()
              frameImage.dispose()
              @gc.dispose
            }
          end
        end
      }
    ).start
    @parent
  end
end
