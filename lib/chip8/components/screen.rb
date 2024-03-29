# frozen_string_literal: true

module Chip8
  class Screen
    attr_reader :buffer

    def initialize(memory)
      @memory = memory
      @buffer = Array.new(BASE_HEIGHT) { Array.new(BASE_WIDTH).fill(0) }
    end

    def draw_buffer
      @buffer.each_with_index do |_val, y|
        @buffer[y].each_with_index do |signal, x|
          draw_pixel(y, x, signal)
        end
      end
    end

    def reset_buffer
      @buffer.each { |row| row.fill(0) }
    end

    def draw_sprite(h, w, sprite_address, num)
      pixel_collision = 0

      for lh in 0...num do
        line =  @memory[sprite_address + lh]

        for lw in 0...8 do
          bit_to_check = 0b10000000 >> lw
          signal       = line & bit_to_check > 0 ? 1 : 0
          ph           = (h + lh) % BASE_HEIGHT
          pw           = (w + lw) % BASE_WIDTH

          pixel_collision = 1 if @buffer[ph][pw] == 1

          @buffer[ph][pw] = signal
        end
      end

      pixel_collision
    end

    private

    def draw_pixel(y, x, signal)
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
