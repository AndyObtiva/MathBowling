require 'glimmer'

# TODO contribute to Glimmer
class Video
  include Glimmer::SWT::CustomWidget

  options :file, :autoplay

  def body
    browser {
      layout_data {
        exclude true
        width 0
        height 0
      }
      text <<~HTML
        <html>
          <head>
            <style>
              body {
                margin: 0;
                padding: 0;
                margin-top: -150px;
              }
            </style>
          </head>
          <body>
            <video id="video" width="100%" #{browser_video_autoplay}>
              <source src="file://#{file}" type="video/mp4">
            Your browser does not support the video tag.
            </video>
          </body>
        </html>
      HTML
    }
  end

  def play
    widget.execute("document.getElementById('video').play()")
  end

  def browser_video_autoplay
    'autoplay' if autoplay
  end
end
