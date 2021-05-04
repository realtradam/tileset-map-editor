# frozen_string_literal: true

class Tileset
  def initialize(directory, x_dimension, y_dimension)
    @tileset = Array.new(23) { Array.new(13) }
    (1..299).each do |iterator|
      iter = iterator - 1
      iter = 299 if iter.zero?
      x = (iterator - 1) % 23
      stylized = iter.to_s
      stylized = "0#{stylized}" while stylized.length < 3
      @tileset[x][((iterator - x) / 23)] = "./assets/kenny/PNG/128/towerDefense_tile#{stylized}.png"
      puts @tileset[x][((iterator - x) / 23)]
    end
    (0...13).each do |why|
      (0...23).each do |eks|
      end
    end
  end

  def get
    @tileset
  end

  #private

  def divisors_of(num)
    (1..num).select { |n|num % n == 0 }
  end
end
