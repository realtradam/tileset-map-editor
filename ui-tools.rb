require 'ruby2d'

module UIToolkit
  # a nice looking box for placing text inside
  module Textbox
    class StandardTextbox
      attr_reader :objects

      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a')
        @base_color = Color.new(base_color)
        border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
        border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
        @objects ||= []
        @base = Rectangle.new(x: border_width + x,
                              y: border_width + y,
                              width: width - (border_width * 2),
                              height: height - (border_width * 2),
                              color: @base_color)
        @objects.push @base
        @top_border = Quad.new(x1: x,
                               y1: y,
                               x2: x + width,
                               y2: y,
                               x3: x + width - border_width,
                               y3: y + border_width,
                               x4: x + border_width,
                               y4: y + border_width,
                               color: border_light)
        @objects.push @top_border
        @right_border = Quad.new(x1: x + width,
                                 y1: y,
                                 x2: x + width,
                                 y2: y + height,
                                 x3: x + width - border_width,
                                 y3: y + height - border_width,
                                 x4: x + width - border_width,
                                 y4: y + border_width,
                                 color: border_light)
        @objects.push @right_border
        @bottom_border = Quad.new(x1: x,
                                  y1: y + height,
                                  x2: x + width,
                                  y2: y + height,
                                  x3: x + width - border_width,
                                  y3: y + height - border_width,
                                  x4: x + border_width,
                                  y4: y + height - border_width,
                                  color: border_dark)
        @objects.push @bottom_border
        @left_border = Quad.new(x1: x,
                                y1: y,
                                x2: x,
                                y2: y + height,
                                x3: x + border_width,
                                y3: y + height - border_width,
                                x4: x + border_width,
                                y4: y + border_width,
                                color: border_dark)
        @objects.push @left_border
      end

      def base_color=(base_color)
        @base_color = Color.new(base_color)
        border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
        border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
        @base.color = @base_color
        @top_border.color = border_light
        @right_border.color = border_light
        @bottom_border.color = border_dark
        @left_border.color = border_dark
      end

      def x
        @top_border.x1
      end

      def x=(x)
        x -= self.x
        @objects.each do |object|
          object.x1 += x
          object.x2 += x
          object.x3 += x
          object.x4 += x
        end
      end

      def y
        @top_border.x1
      end

      def y=(y)
        y -= self.y
        @objects.each do |object|
          object.y1 += y
          object.y2 += y
          object.y3 += y
          object.y4 += y
        end
      end

      def width
        @top_border.x2 - @top_border.x1
      end

      def width=(width)
        width -= self.width
        @base.x2 += width
        @base.x3 += width
        @top_border.x2 += width
        @top_border.x3 += width
        @right_border.x1 += width
        @right_border.x2 += width
        @right_border.x3 += width
        @right_border.x4 += width
        @bottom_border.x2 += width
        @bottom_border.x3 += width
      end

      def height
        @right_border.y2 - @right_border.y1
      end

      def height=(height)
        height -= self.height
        @base.y3 += height
        @base.y4 += height
        @right_border.y2 += height
        @right_border.y3 += height
        @bottom_border.y1 += height
        @bottom_border.y2 += height
        @bottom_border.y3 += height
        @bottom_border.y4 += height
        @left_border.y2 += height
        @left_border.y3 += height
      end
    end

    class TaperedTextbox < StandardTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a')
        super(x: x + width - border_width, y: y, width: -(width - (border_width * 2)), height: height, border_width: border_width, base_color: base_color)
      end

      def x
        @top_border.x3
      end

      def width
        @top_border.x3 - @top_border.x4
      end

      def width=(width)
        width -= self.width
        @base.x2 -= width
        @base.x3 -= width
        @top_border.x2 -= width
        @top_border.x3 -= width
        @right_border.x1 -= width
        @right_border.x2 -= width
        @right_border.x3 -= width
        @right_border.x4 -= width
        @bottom_border.x2 -= width
        @bottom_border.x3 -= width
        self.x += width
      end
    end
    class RoundedTextbox < TaperedTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a')
        @objects ||= []
        @base_color = Color.new(base_color)
        border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
        border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
        @top_left = Circle.new(x: x + border_width,
                               y: y + border_width,
                               radius: border_width,
                               color: border_light)
        @objects << @top_left
        @top_right = Circle.new(x: x + width - border_width,
                               y: y + border_width,
                               radius: border_width,
                               color: border_dark)
        @objects << @top_right
        @bottom_right = Circle.new(x: x + width - border_width,
                               y: y + height - border_width,
                               radius: border_width,
                               color: border_dark)
        @objects << @bottom_right
        @bottom_left = Circle.new(x: x + border_width,
                               y: y + height - border_width,
                               radius: border_width,
                               color: border_dark)
        @objects << @top_right
        super(x: x, y: y, width: width, height: height, border_width: border_width, base_color: base_color)
      end

      def x=(x)
        x -= self.x
        @objects.each do |object|
          if !object.is_a? Circle
            object.x1 += x
            object.x2 += x
            object.x3 += x
            object.x4 += x
          else
            object.x += x
          end
        end
      end

      def y=(y)
        y -= self.y
        @objects.each do |object|
          if !object.is_a? Circle
            object.y1 += y
            object.y2 += y
            object.y3 += y
            object.y4 += y
          else
            object.y += y
          end
        end
      end
      def width=(width)
        #@top_left.x -= width
        #@top_right.x -= width
        super(width)
      end
    end
  end

  # A Hollow Textbox
  class Borderbox
    attr_reader :objects
    def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a')
      @base_color = Color.new(base_color)
      border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
      border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
      @objects = []
      @top_border = Quad.new(x1: x,
                             y1: y,
                             x2: x + (border_width * 2) + width,
                             y2: y,
                             x3: x + (border_width * 1) + width,
                             y3: y + border_width,
                             x4: x + border_width,
                             y4: y + border_width,
                             color: border_light)
      @objects.push @top_border
      @right_border = Quad.new(x1: x + (border_width * 2) + width,
                               y1: y,
                               x2: x + (border_width * 2) + width,
                               y2: y + (border_width * 2) + height,
                               x3: x + border_width + width,
                               y3: y + border_width + height,
                               x4: x + border_width + width,
                               y4: y + border_width,
                               color: border_light)
      @objects.push @right_border
      @bottom_border = Quad.new(x1: x,
                                y1: y + (border_width * 2)+ height,
                                x2: x + (border_width * 2) + width,
                                y2: y + (border_width * 2) + height,
                                x3: x + (border_width * 1) + width,
                                y3: y + border_width + height,
                                x4: x + border_width,
                                y4: y + border_width + height,
                                color: border_dark)
      @objects.push @right_border
      @left_border = Quad.new(x1: x,
                              y1: y,
                              x2: x,
                              y2: y + (border_width * 2) + height,
                              x3: x + border_width,
                              y3: y + border_width + height,
                              x4: x + border_width,
                              y4: y + border_width,
                              color: border_dark)
      @objects.push @left_border
    end
    def base_color=(base_color)
      @base_color = Color.new(base_color)
      border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
      border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
      @top_border.color = border_light
      @right_border.color = border_light
      @bottom_border.color = border_dark
      @left_border.color = border_dark
    end
  end
end
