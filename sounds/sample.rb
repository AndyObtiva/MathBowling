require 'sounder'
Sounder::System.set_volume 70 # 0-100

Sounder.play File.expand_path('../bowling2.mp3', __FILE__)

#sound = Sounder::Sound.new "/path/to/audio/file"
#sound.play
#
#my_group = Sounder::SoundGroup.new(
#  :sound_one  => File.expand_path('../../lib/support/sound1.m4a', __FILE__),
#  "sound_two" => File.expand_path('../../lib/support/sound2.m4a', __FILE__)
#)
#my_group.play "tw"  # fuzzy matching of names
#my_group.random     # plays a random sound from the group
#my_group.usage      # returns a usage string with all the sound
