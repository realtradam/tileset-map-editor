require 'ruby2d'

module UIToolkit
  # a nice looking box for placing text inside
  # only StandardTextbox works as intended
  module Textbox
    class StandardTextbox
      attr_reader :objects, :base,
        :top_border, :right_border,
        :left_border, :bottom_border,
        :base_color, :swap_colors

      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', swap_colors: false, z: 99)
        @base_color = Color.new(base_color)
        border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
        border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
        @objects ||= []
        @base ||= Rectangle.new(x: border_width + x,
                                y: border_width + y,
                                width: width - (border_width * 2),
                                height: height - (border_width * 2),
                                color: @base_color,
                                z: z)
        @objects.push @base
        @top_border = Quad.new(x1: x,
                               y1: y,
                               x2: x + width,
                               y2: y,
                               x3: x + width - border_width,
                               y3: y + border_width,
                               x4: x + border_width,
                               y4: y + border_width,
                               color: border_light,
                               z: z)
        @objects.push @top_border
        @right_border = Quad.new(x1: x + width,
                                 y1: y,
                                 x2: x + width,
                                 y2: y + height,
                                 x3: x + width - border_width,
                                 y3: y + height - border_width,
                                 x4: x + width - border_width,
                                 y4: y + border_width,
                                 color: border_light,
                                 z: z)
        @objects.push @right_border
        @bottom_border = Quad.new(x1: x,
                                  y1: y + height,
                                  x2: x + width,
                                  y2: y + height,
                                  x3: x + width - border_width,
                                  y3: y + height - border_width,
                                  x4: x + border_width,
                                  y4: y + height - border_width,
                                  color: border_dark,
                                  z: z)
        @objects.push @bottom_border
        @left_border = Quad.new(x1: x,
                                y1: y,
                                x2: x,
                                y2: y + height,
                                x3: x + border_width,
                                y3: y + height - border_width,
                                x4: x + border_width,
                                y4: y + border_width,
                                color: border_dark,
                                z: z)
        @objects.push @left_border
        @swap_colors = false
        self.swap_colors = swap_colors
      end

      def remove
        @objects.each do |object|
          object.remove
        end
      end

      def add
        @objects.each do |object|
          object.add
        end
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

      def swap_colors=(swap_colors)
          if swap_colors
            border_base= Color.new([[@base_color.r - 0.1, 0].max, [@base_color.g - 0.1, 0].max, [@base_color.b - 0.1, 0].max, @base_color.a])
            border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
            border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
            @left_border.color = border_base
            @bottom_border.color = border_base
            @top_border.color = border_dark
            @right_border.color = border_dark
            @base.color = border_light
          else
            border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
            border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
            @left_border.color = border_dark
            @bottom_border.color = border_dark
            @top_border.color = border_light
            @right_border.color = border_light
            @base.color = @base_color
          end
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
        @top_border.y1
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

      def border_width
        @top_border.y4 - @top_border.y1
      end

      def border_width=(border_width)
        border_width -= self.border_width
        @base.width += border_width * 2
        @base.height += border_width * 2
        @top_border.x3 += border_width
        @top_border.y3 -= border_width
        @top_border.x4 -= border_width
        @top_border.y4 -= border_width
        @right_border.x3 += border_width
        @right_border.y3 += border_width
        @right_border.x4 += border_width
        @right_border.y4 -= border_width
        @bottom_border.x3 += border_width
        @bottom_border.y3 += border_width
        @bottom_border.x4 -= border_width
        @bottom_border.y4 += border_width
        @left_border.x3 -= border_width
        @left_border.y3 += border_width
        @left_border.x4 -= border_width
        @left_border.y4 -= border_width
        @base.x = @top_border.x4
        @base.y = @top_border.y4
      end

      def z
        @object[0].z
      end

      def z=(z)

        @objects.each do |object|
          object.z = z
        end
      end

      def contains(x, y)
        (x >= self.x) && (x <= self.x + width) && (y >= self.y) && (y <= self.y + height)
      end
    end

    class TaperedTextbox < StandardTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', z: 99)
        super(x: x + width - border_width, y: y, width: -(width - (border_width * 2)), height: height, border_width: border_width, base_color: base_color, z: z)
        @base.x += border_width
        @base.width -= border_width * 2
      end

      def x
        @top_border.x3
      end

      def width
        @top_border.x4 - @top_border.x3
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
      attr_reader :top_left, :top_right,
        :bottom_right, :bottom_left

      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', z: 99)
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
        @objects << @bottom_left
        super(x: x, y: y, width: width, height: height, border_width: border_width, base_color: base_color, z: z)
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
        tempwidth = width - self.width
        @top_left.x -= tempwidth
        @bottom_left.x -= tempwidth
        super(width)
      end

      def base_color=(base_color)
        @base_color = Color.new(base_color)
        border_light = Color.new([[@base_color.r - 0.2, 0].max, [@base_color.g - 0.2, 0].max, [@base_color.b - 0.2, 0].max, @base_color.a])
        border_dark = Color.new([[@base_color.r - 0.4, 0].max, [@base_color.g - 0.4, 0].max, [@base_color.b - 0.4, 0].max, @base_color.a])
        @top_left.color = border_light
        @top_right.color = @bottom_left.color = @bottom_right.color = border_dark
        super(base_color)
      end

      def border_width=(border_width)
        super(border_width)
        @top_left.x = x + border_width
        @top_left.y = y + border_width
        @top_left.radius = border_width
        @top_right.x = x + width - border_width
        @top_right.y = y + border_width
        @top_right.radius = border_width
        @bottom_right.x = x + width - border_width
        @bottom_right.y = y + height - border_width
        @bottom_right.radius = border_width
        @bottom_left.x = x + border_width
        @bottom_left.y = y + height - border_width
        @bottom_left.radius = border_width
      end
    end
  end

  # A Hollow Textbox
  # Only StandardBorderbox works as intended
  module Borderbox
    class StandardBorderbox < UIToolkit::Textbox::StandardTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', z: 99)
        super(x: x, y: y, width: width, height: height, border_width: border_width, base_color: base_color, z: z)
        @base.remove
        @objects.delete @base
      end
    end
    class TaperedBorderbox < UIToolkit::Textbox::TaperedTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', z: 99)
        super(x: x, y: y, width: width, height: height, border_width: border_width, base_color: base_color, z: z)
        @base.remove
        @objects.delete @base
      end
    end
    class RoundedBorderbox < UIToolkit::Textbox::RoundedTextbox
      def initialize(x: 0, y: 0, width: 90, height: 90, border_width: 10, base_color: '#ff7f2a', z: 99)
        super(x: x, y: y, width: width, height: height, border_width: border_width, base_color: base_color, z: z)
        @base.remove
        @objects.delete @base
      end
    end
  end
end
