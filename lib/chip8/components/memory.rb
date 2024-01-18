# frozen_string_literal: true

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

  def load_sprites(sprites)
    for x in CHARSET_ADDRESS..CHARSET_ADDRESS + (sprites.size - 1) do
      @memory[x] = sprites[x]
    end
  end
end
