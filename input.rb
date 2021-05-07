require 'ruby2d'

class Input
  @down = {}
  @held = {}
  @up = {}

  def self.down(char, toggle_on: false)
    #puts 'work' if char == 'left' if toggle_on
    if toggle_on
      @down[char] = true
    else
      !@down[char].nil?
    end
  end

  def self.held(char, toggle_on: false)
    if toggle_on
      @held[char] = true
    else
      !@held[char].nil?
    end
  end

  def self.up(char, toggle_on: false)
    if toggle_on
      @up[char] = true
    else
      !@up[char].nil?
    end
  end

  class <<self
    alias pressed down
    alias released up
  end

  def self.any(char)
    !@pressed[char].nil? || !@held[char].nil? || !@released[char].nil?
  end

  def self.reset
    @down = {}
    @held = {}
    @up = {}
  end
end

on :mouse do |event|
  Input.public_send(event.type, event.button.to_s, toggle_on: true) unless event.button.nil?
end

on :key do |event|
  Input.public_send(event.type, event.key, toggle_on: true)
end
