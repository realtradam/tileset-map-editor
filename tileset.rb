# frozen_string_literal: true

# A Tileset :) TODO
class Tileset
  attr_reader :tileset,
              :columns, :rows,
              :width, :height

  def initialize(directory, width, height)
    @width = width
    @height = height
    if directory[-1] == '/'
      directory = "#{directory}*"
    elsif directory[-1] != '*'
      directory = "#{directory}/*"
    end

    images = Dir[directory].sort
    factors = divisors_of(images.length)
    @columns = factors[factors.length / 2]
    @rows = factors[(factors.length / 2) - 1]

    @tileset = Array.new(@columns) { Array.new(@rows, nil) }
    images.each_with_index do |image, index|
      x = index % @columns
      #@tileset[x] = [] if @tileset[x].nil?
      @tileset[x][((index - x) / @columns)] = image
    end
  end

  def create_image(column:, row:, x: 0, y: 0, z: 0, width: self.width, height: self.height)
    Image.new(tileset[column][row],
              width: width,
              height: height,
              x: x,
              y: y,
              z: z)
  end

  private

  def divisors_of(num)
    (1..num).select { |n| (num % n).zero? }
  end
end
