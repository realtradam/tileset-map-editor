require 'ruby2d'
require_relative 'ui-tools'
require_relative 'math_plus'

module UI
  def self.load
    UI::Main.load
    UI::Popup.load
  end

  module Main
    class <<self
      attr_reader :objects, :mouse_follow, :history_slots, :popup_button
    end

    def self.height
      120
    end

    def self.load
      @objects = []
      @objects.push UIToolkit::Textbox::StandardTextbox.new(y: Window.height - 120,
                                                            height: height,
                                                            width: Window.width,
                                                            border_width: 12,
                                                            base_color: 'orange',
                                                            z: 99)
      @history_slots = Array.new((((Window.width - 90) / 75) - 1), nil)
      puts @history_slots.length
      (0...@history_slots.length).each do |iterate|
        @history_slots[iterate] = [UIToolkit::Borderbox::StandardBorderbox.new(y: Window.height - 90,
                                                                               x: (75 * (iterate + 1)) - 45,
                                                                               width: 60,
                                                                               height: 60,
                                                                               border_width: 5,
                                                                               base_color: 'green',
                                                                               z: 99), nil]
        @objects.push @history_slots[iterate][0]
      end
      @history_slots[0][0].base_color = 'lime'
      @popup_button = UIToolkit::Textbox::StandardTextbox.new(y: Window.height - 90,
                                                              x: @objects.last.x + 75,
                                                              width: (Window.width - 30) - (@objects.last.x + 75),
                                                              height: 60,
                                                              border_width: 5,
                                                              base_color: 'green',
                                                              z: 99)
      @objects.push @popup_button
      @mouse_follow = UIToolkit::Borderbox::TaperedBorderbox.new(width: 128 + 24,
                                                                 height: 128 + 24,
                                                                 border_width: 24,
                                                                 base_color: 'fuchsia',
                                                                 z: 98)
      @objects.push @mouse_follow
    end
  end
  module Popup
    class <<self
      attr_reader :objects, :menubox, :tileset, :tiles
    end

    def self.load
      @objects = []
      @menubox = UIToolkit::Textbox::StandardTextbox.new(x: Window.width * 0.01,
                                                         y: Window.width * 0.01,
                                                         width: Window.width * 0.98,
                                                         height: Window.height - (Window.width * 0.02) - 120,
                                                         border_width: 12,
                                                         base_color: [1.0, 0.52, 0.1, 0.8],
                                                         z:99)
      @menubox.remove
      @objects.push @menubox
      maxinnerwidth = @menubox.width - 24
      maxinnerheight = @menubox.height - 24
      menuaspect = maxinnerwidth / maxinnerheight.to_f
      @tileset = Tileset.new('./assets/kenny/PNG/128', 128, 128)
      tilesetaspect = (@tileset.width * @tileset.columns) / (@tileset.height * @tileset.rows).to_f
      use_divisor = nil
      if menuaspect > tilesetaspect
        # make height match or less
        totalheight = @tileset.height * @tileset.rows
        if @tileset.width <= @tileset.height
          MathPlus.divisors_of(@tileset.width).sort.each do |divisor|
            if divisor == @tileset.width
              # exausted search of even divisor and failed, just use exact uneven match instead
              use_divisor = (@tileset.width * @tileset.columns) / maxinnerwidth.to_f
              break
            end
            puts "(#{totalheight} / #{divisor}) + #{@tileset.rows} < #{maxinnerheight}"
            if (totalheight / divisor) + @tileset.rows < maxinnerheight
              # use divisor
              use_divisor = divisor.to_f
              break
            end
          end
        else
          MathPlus.divisors_of(@tileset.height).sort.each do |divisor|
            if (totalheight / divisor) + @tileset.rows < maxinnerheight
              # use divisor
              use_divisor = divisor.to_f
              break
            end
          end
        end
      else
        # make width match or less
      end
      @tiles = []
      (0...@tileset.rows).each do |row|
        (0...@tileset.columns).each do |column|
          @tiles.push @tileset.create_image(column: column,
                                row: row,
                                x: Window.width - (@menubox.x + 48 + (@tileset.width * @tileset.columns) / use_divisor)  + (column * ((@tileset.width / use_divisor) + 1)),
                                y: Window.height - (@menubox.y + 36 + 120 + (@tileset.height * @tileset.rows) / use_divisor) + (row * ((@tileset.height / use_divisor) + 1)),
                                width: @tileset.width / use_divisor,
                                height: @tileset.height / use_divisor,
                                z: 101)
          @objects.push @tiles.last
          @tiles.last.remove
        end
      end
      @menubox.x = @tiles[0].x - 24
      @menubox.y = @tiles[0].y - 24
      @menubox.width = 48 + ((@tileset.width * @tileset.columns) / use_divisor) + @tileset.columns - 1
      @menubox.height = 48 + ((@tileset.height * @tileset.rows) / use_divisor) + @tileset.rows - 1
    end

    def self.showing_menu
      @showing_menu ||= false
    end

    def self.showing_menu=(show)
      if show
        @menubox.add
      else
        @menubox.remove
      end
      @showing_menu = show
    end
  end
end
