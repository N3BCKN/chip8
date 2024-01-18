# frozen_string_literal: true

module Chip8
  class Screen
    attr_reader :buffer

    def initialize(memory)
      @memory = memory
      @buffer = []
    end

    def draw_buffer
      for y in 0..BASE_HEIGHT do
        @buffer << []

        for x in 0..BASE_WIDTH do
          @buffer[y] << 0
          draw_pixel(x, y, 0)
        end
      end
    end

    def reset_buffer
      @buffer.each { |row| row.fill(0) }
    end

    def draw_sprite(h, w, sprite_address, num)
      for ly in 0...num do
        line =  @memory[sprite_address + ly]
        for lx in 0...8 do
          bit_to_check = 0b10000000 >> lx
          signal       = line & bit_to_check
          draw_pixel(h + lx, w + ly, signal)
        end
      end
    end

    private

    def draw_pixel(x, y, signal)
      return if signal.zero?

      Square.new(
        x: x * SCREEN_MULTIPLIER,
        y: y * SCREEN_MULTIPLIER,
        size: SCREEN_MULTIPLIER,
        color: COLOR
      )
    end
  end
end
