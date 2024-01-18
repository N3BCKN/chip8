# frozen_string_literal: true

class Screen
  attr_reader :buffer

  def initialize
    @buffer = []
  end

  def draw_buffer
    for y in 0..BASE_HEIGHT do
      @buffer << []

      for x in 0..BASE_WIDTH do
        signal = rand > 0.5 ? 0 : 1
        @buffer[y] << signal
        draw_pixel(x, y, signal) # if signal == 1
      end
    end
  end

  def reset_buffer
    @buffer.each { |row| row.fill(0) }
  end

  private

  def draw_pixel(x, y, signal)
    color = signal == 1 ? COLOR : BG_COLOR
    Square.new(
      x: x * SCREEN_MULTIPLIER,
      y: y * SCREEN_MULTIPLIER,
      size: SCREEN_MULTIPLIER,
      color: color
    )
  end
end