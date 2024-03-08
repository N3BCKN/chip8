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
      low_byte  = @memory[index+1]
      high_byte << 8 | low_byte
    end

    def load_sprites(sprites)
      sprites.each_with_index { |v, i| @memory[i] = v }
    end

    def load_rom(rom)
      return unless rom.size + LOAD_PROGRAM_ADDRESS <= MEMORY_SIZE # todo custom error class heres
      rom.each_with_index {|v, i| @memory[LOAD_PROGRAM_ADDRESS + i] = v }
    end
  end
end
