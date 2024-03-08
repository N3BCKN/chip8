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

    def opcode(index)
      high_byte = @memory[index]
      low_byte  = @memory[index + 1]
      high_byte << 8 | low_byte
    end
  end
end
