# frozen_string_literal: true

require 'ruby2d'
require_relative 'lib/camera/camera'
require_relative 'tileset'

@eks = 0
@why = 0

on :key_down do |event|
  if event.key == 'w'
    @why -= 1
    @why %= 13
  end
  if event.key == 's'
    @why += 1
    @why %= 13
  end
  if event.key == 'a'
    @eks -= 1
    @eks %= 23
  end
  if event.key == 'd'
    @eks += 1
    @eks %= 23
  end
end
@test = Sprite.new('./Monster02.png',
                   clip_width: 48,
                   clip_height: 48,
                   width: 100,
                   height: 100,
                   x: 0,
                   y: 0,
                   loop: true)
@test2 = Sprite.new('./Monster02-RGB.png',
                   clip_width: 48,
                   clip_height: 48,
                   width: 100,
                   height: 100,
                   x: 100,
                   y: 0,
                   loop: true)
@test.play
@test2.play
update do
  #Camera << Image.new(Tileset.get[@eks][@why])
  #Camera.redraw
end

show
