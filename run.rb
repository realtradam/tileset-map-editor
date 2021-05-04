# frozen_string_literal: true

require 'ruby2d'
require_relative 'lib/camera/camera'
require_relative 'tileset'

set width: 1024, height: 720

@eks = 0
@why = 0

on :key_down do |event|
  if event.key == 'w'
    @why -= 1
  end
  if event.key == 's'
    @why += 1
  end
  if event.key == 'a'
    @eks -= 1
  end
  if event.key == 'd'
    @eks += 1
  end
end
on :mouse_up do |event|
  case event.button
  when :left
    @new = @yep.create_image(@selected_item[0], @selected_item[1])
    @new.x = Window.mouse_x - (Window.mouse_x % 128)
    @new.y = Window.mouse_y - (Window.mouse_y % 128)
  end
end
on :mouse_scroll do |event|
  @selected_item[0] += event.delta_y
  puts "=="
  pp @selected_item
  @selected_item[1] += @selected_item[0] / @yep.width
  @selected_item[0] %= @yep.width
  pp @selected_item
  @selected_item[1] %= @yep.height
  pp @selected_item
end
@yep = Tileset.new('./assets/kenny/PNG/128', 128, 128)
@yep.tileset.each do |thing|
  thing.each do |stuff|
    pp stuff
  end
end

@selected_item = [0,0]
@selected_image = @yep.create_image(@selected_item[0], @selected_item[1])

update do
  @selected_image.remove
  @selected_image = @yep.create_image(@selected_item[0], @selected_item[1])
  @selected_image.x = Window.mouse_x - (Window.mouse_x % 128)
  @selected_image.y = Window.mouse_y - (Window.mouse_y % 128)
end

show
