# frozen_string_literal: true

Dir[File.join(__dir__, 'wrappers', '*.rb')].sort.each { |file| require file }

# Handles rendering objects relative
# to a camera location
module Camera
  class <<self

    private
    # Contains all objects that are tracked
    def objects
      @objects ||= []
    end
  end

  def self.debug_x
    @debug_x ||= 0
  end

  def self.debug_x=(debug_x)
    @debug_x = debug_x
  end

  def self.debug_y
    @debug_y ||= 0
  end

  def self.debug_y=(debug_y)
    @debug_y = debug_y
  end

  # Adding objects so they are
  # tracked by the Camera
  def self.<<(item)
    case item
    when Triangle
      item.extend Camera::TriangleWrapped
    when Square
      item.extend Camera::SquareWrapped
    when Rectangle
      item.extend Camera::RectangleWrapped
    when Quad
      item.extend Camera::QuadWrapped
    when Line
      item.extend Camera::LineWrapped
    when Circle
      item.extend Camera::CircleWrapped
    when Image
      item.extend Camera::ImageWrapped
    when Sprite
      item.extend Camera::SpriteWrapped
    when Text
      item.extend Camera::TextWrapped
    else
      puts 'Warning: Non-standard Object added to Camera'
      puts '  Object may not behave as expected'
    end
    objects.push(item) unless objects.include?(item)
  end

  def self.remove(item)
    objects.delete(item) if objects.include?(item)
  end

  # Redraw all objects that
  # are tracked by the Camera
  def self.redraw(auto_purge: false)
    if auto_purge
      objects.each do |item|
        if item.nil?
          puts 'Warning: Nil Object detected in Camera'
          puts '  Nil Object removed'
          objects.delete(obj)
        else
          item.redraw
        end
      end
    else
      objects.each(&:redraw)
    end
  end

  # Convert screenspace coordinates into worldspace camera ones
  def self.coordinate_to_worldspace(x, y)
    angle = Camera.angle * (Math::PI / 180)
    half_width = Window.width * 0.5
    half_height = Window.height * 0.5

    [(((x - half_width) / zoom) * Math.cos(-angle)) - (((y - half_height) / zoom) * Math.sin(-angle)) + self.x,
     (((x - half_width) / zoom) * Math.sin(-angle)) + (((y - half_height) / zoom) * Math.cos(-angle)) + self.y]
  end

  # Convert worldspace camera coordinates into screenspace ones
  def self.coordinate_to_screenspace(x, y)
    angle = Camera.angle * (Math::PI / 180)
    [(((x - Camera.x) * Math.cos(angle)) - ((y - Camera.y) * Math.sin(angle))) * Camera.zoom + (Window.width * 0.5),
     (((x - Camera.x) * Math.sin(angle)) + ((y - Camera.y) * Math.cos(angle))) * Camera.zoom + (Window.height * 0.5)]
  end

  def self.mouse
    coordinate_to_worldspace(Window.mouse_x, Window.mouse_y)
  end

  # Variables changing Camera properties
  def self._x(x)
    @x += x
  end

  def self._y(y)
    @y += y
  end

  def self.x
    @x ||= 0
  end

  def self.x=(x)
    @x = x
  end

  def self.y
    @y ||= 0
  end

  def self.y=(y)
    @y = y
  end

  def self.zoom
    @zoom ||= 1.0
  end

  def self.zoom=(zoom)
    @zoom = zoom
  end

  def self.angle
    @angle ||= 0
  end

  def self.angle=(angle)
    angle %= 360
    @angle = angle
  end
end
