# frozen_string_literal: true

require 'ruby2d'
require_relative 'lib/camera/camera'
require_relative 'tileset'
require_relative 'ui-tools'

set width: 1024, height: 720

set background: 'navy'

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
                                      x: (Camera.mouse[0] - (Camera.mouse[0] % (128 + 12))),
                                      y: (Camera.mouse[1] - (Camera.mouse[1] % (128 + 12))))
  Camera << @new
  end
end
on :mouse_scroll do |event|
  @selected_item[0] += event.delta_y
  if @selected_item[0] >= @yep.columns
    @selected_item[1] = (@selected_item[1] + 1) % @yep.rows
  elsif @selected_item[0].negative?
    @selected_item[1] = (@selected_item[1] - 1) % @yep.rows
  end
  @selected_item[0] %= @yep.columns
end
@yep = Tileset.new('./assets/kenny/PNG/128', 128, 128)

@yep.tileset.each do |thing|
  thing.each do |stuff|
    #stuff
  end
end

(0...@yep.rows).each do |row|
  (0...@yep.columns).each do |column|
    Camera << @yep.create_image(column: column, row: row, x: (column * (128 + 12)), y: (row * (128 + 12)))
  end
end

@selected_item = [0,0]
@selected_image = @yep.create_image(column: @selected_item[0], row: @selected_item[1])

Camera.zoom = 0.25

@textbox = UIToolkit::Textbox::RoundedTextbox.new(y: Window.height - 100, height: 100, width: Window.width, border_width: 35, base_color: 'fuchsia')
@borderbox = UIToolkit::Borderbox.new(height: 100, width: Window.width - 30, border_width: 15, base_color: 'fuchsia')

@timer = 0
update do
  @timer += 1
  @timer %= 60
  if (@timer % 30).zero?
    @textbox.base_color = Color.new 'random'
    @textbox.x += 1
    @textbox.y -= 1
    @textbox.width -= 15
    @borderbox.base_color = Color.new 'random'
    puts @textbox.x
  end
  Camera.remove @selected_image
  @selected_image.remove
  @selected_image = @yep.create_image(column: @selected_item[0],
                                      row: @selected_item[1],
                                      x: (Camera.mouse[0] - (Camera.mouse[0] % (128 + 12))),
                                      y: (Camera.mouse[1] - (Camera.mouse[1] % (128 + 12))))
  Camera << @selected_image
  Camera.redraw
end

show
