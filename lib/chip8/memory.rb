# frozen_string_literal: true

class Memory
  def initialize
    @memory = Array.new(MEMORY_SIZE).fill(0)
  end

  def reset
    @memory.fill(0)
  end

  def []=(location, value)
    @memory[location] = value
  end

  def [](location)
    @memory[location]
  end
end
