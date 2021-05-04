# frozen_string_literal: true

require 'ruby2d'
require_relative 'lib/camera/camera'
require_relative 'tileset'

set width: 1024, height: 720

@eks = 0
@why = 0

on :key_held do |event|
  if event.key == 'w'
    Camera.y += -10
  end
  if event.key == 's'
    Camera.y += 10
  end
  if event.key == 'a'
    Camera.x += -10
  end
  if event.key == 'd'
    Camera.x += 10
  end
end
on :mouse_up do |event|
  case event.button
  when :left
    @new = @yep.create_image(column: @selected_item[0],
                             row: @selected_item[1],
                             x: Window.mouse_x - (Window.mouse_x % 128),
                             y: Window.mouse_y - (Window.mouse_y % 128))
  end
end
on :mouse_scroll do |event|
  @selected_item[0] += event.delta_y
  @selected_item[1] += @selected_item[0] / @yep.columns
  @selected_item[0] %= @yep.columns
  @selected_item[1] %= @yep.rows
end
@yep = Tileset.new('./assets/kenny/PNG/128', 128, 128)

@yep.tileset.each do |thing|
  thing.each do |stuff|
    #stuff
  end
end

(0...@yep.rows).each do |row|
  (0...@yep.columns).each do |column|
    Camera << @yep.create_image(column: column, row: row, x: (column * 128) + (12 * column), y: (row * 128) + (row * 12))
  end
end

@selected_item = [0,0]
@selected_image = @yep.create_image(column: @selected_item[0], row: @selected_item[1])

Camera.zoom = 0.25

update do
  @selected_image.remove
  @selected_image = @yep.create_image(column: @selected_item[0],
                                      row: @selected_item[1],
                                      x: (Window.mouse_x - (Window.mouse_x % 128)),
                                      y: (Window.mouse_y - (Window.mouse_y % 128)))
  Camera.redraw
end

show
