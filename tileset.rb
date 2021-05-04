# frozen_string_literal: true

# A Tileset :) TODO
class Tileset
  attr_reader :tileset,
              :x_dimension, :y_dimension,
              :width, :height

  def initialize(directory, x_dimension, y_dimension)
    puts directory
    @x_dimension = x_dimension
    @y_dimension = y_dimension
    if directory[-1] == '/'
      directory = "#{directory}*"
    elsif directory[-1] != '*'
      directory = "#{directory}/*"
    end

    puts directory
    images = Dir[directory].sort
    factors = divisors_of(images.length)
    puts factors
    @width = factors[factors.length / 2]
    @height = factors[(factors.length / 2) - 1]

    @tileset = Array.new(@width, nil) { Array.new(@height, nil) }
    images.each_with_index do |image, index|
      x = index % @width
      puts "Image #{index} is #{image}"
      #@tileset[x] = [] if @tileset[x].nil?
      @tileset[x][((index - x) / @width)] = image
      #puts @tileset[x][((index - x) / 23)]
    end
  end

  def create_image(x_tile, y_tile)
    Image.new(tileset[x_tile][y_tile],
              width: x_dimension,
              height: y_dimension)
  end

  private

  def divisors_of(num)
    (1..num).select { |n|num % n == 0 }
  end
end
