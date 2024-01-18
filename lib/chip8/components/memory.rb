# frozen_string_literal: true

module Chip8
  class Memory
    def initialize
      @memory = Array.new(MEMORY_SIZE, 0)
    end

    def []=(location, value)
      @memory[location] = value
    end

    def [](location)
      @memory[location]
    end

    def reset
      @memory.fill(0)
    end

    def load_sprites
      SPRITES.each_with_index { |value, index| @memory[index] = value }
    end
  end
end
