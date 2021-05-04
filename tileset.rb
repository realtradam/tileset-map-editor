# frozen_string_literal: true

# A Tileset :) TODO
class Tileset
  attr_reader :tileset,
              :columns, :rows,
              :width, :height

  def initialize(directory, width, height)
    puts directory
    @width = width
    @height = height
    if directory[-1] == '/'
      directory = "#{directory}*"
    elsif directory[-1] != '*'
      directory = "#{directory}/*"
    end

    puts directory
    images = Dir[directory].sort
    factors = divisors_of(images.length)
    puts factors
    @columns = factors[factors.length / 2]
    @rows = factors[(factors.length / 2) - 1]

    @tileset = Array.new(@columns, nil) { Array.new(@rows, nil) }
    images.each_with_index do |image, index|
      x = index % @columns
      puts "Image #{index} is #{image}"
      #@tileset[x] = [] if @tileset[x].nil?
      @tileset[x][((index - x) / @columns)] = image
      #puts @tileset[x][((index - x) / 23)]
    end
  end

  def create_image(column:, row:, x: 0, y: 0)
    Image.new(tileset[column][row],
              width: width,
              height: height,
              x: x,
              y: y)
  end

  private

  def divisors_of(num)
    (1..num).select { |n| (num % n).zero? }
  end
end
