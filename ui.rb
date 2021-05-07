require 'ruby2d'
require_relative 'ui-tools'

module UI
  def self.load
    UI::Main.load
    UI::Popup.load
  end

  module Main
    class <<self
      attr_reader :objects, :mouse_follow, :history_slots
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
      attr_reader :objects, :menubox
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
      @objects.push @menubox
    end
  end
end
