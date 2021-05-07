# frozen_string_literal: true

require 'ruby2d'
require_relative 'lib/camera/camera'
require_relative 'tileset'
require_relative 'ui'
require_relative 'input'

set width: 640, height: 480
#set width: 1280, height: 720
#set width: 1920, height: 1080
set background: 'navy'

UI.load

@eks = 0
@why = 0

# Create on click
    #@new = @yep.create_image(column: @selected_item[0],
    #                                    row: @selected_item[1],
    #                                    x: (Camera.mouse[0] - (Camera.mouse[0] % (128 + 12))),
    #                                    y: (Camera.mouse[1] - (Camera.mouse[1] % (128 + 12))))
    #Camera << @new

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

#@selected_item = [0,0]
#@selected_image = @yep.create_image(column: @selected_item[0], row: @selected_item[1])

Camera.zoom = 0.25

UI::Main.mouse_follow.objects.each do |object|
  Camera << object
end
@timer = 0
update do
  Camera.x += 10 if Input.held('d')
  Camera.x -= 10 if Input.held('a')
  Camera.y -= 10 if Input.held('w')
  Camera.y += 10 if Input.held('s')
  @timer += 1
  @timer %= 60
  if (@timer % 30).zero?
  end
  #Camera.remove @selected_image
  #@selected_image.remove
  UI::Main.mouse_follow.x = (Camera.mouse[0] - (Camera.mouse[0] % (128 + 12) + 12))
  UI::Main.mouse_follow.y = (Camera.mouse[1] - (Camera.mouse[1] % (128 + 12) + 12))
  UI::Main.history_slots.each do |item|
    # Ignore if to the left of UI boxes
    if (Window.mouse_x - 30).positive? && \
        # Ignore if to the right of UI boxes
        (Window.mouse_x < (UI::Main.history_slots.length * 75) + 15) && \
        # If within a box, and not between 2 boxes
        (((Window.mouse_x - 30) % 75) <= 60) && \
        # Ignore below boxes
        (Window.mouse_y >= Window.height - 90) && \
        # Ignore above boxes
        (Window.mouse_y <= Window.height - 30) 
      if item[0].contains(Window.mouse_x, Window.mouse_y)
        item[0].base_color = 'lime'
      else
        item[0].base_color = 'green'
      end
    end
  end
  #@selected_image = @yep.create_image(column: @selected_item[0],
  #                                    row: @selected_item[1],
  #                                    x: (Camera.mouse[0] - (Camera.mouse[0] % (128 + 12))),
  #                                    y: (Camera.mouse[1] - (Camera.mouse[1] % (128 + 12))))
  #Camera << @selected_image
  puts "yep" if Input.down('left')
  puts "yup" if Input.down('middle')
  puts "yorp" if Input.down('right')
  Input.reset
  Camera.redraw
end

show
