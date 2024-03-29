# frozen_string_literal: true

module Chip8
  class StackOverflowError < StandardError
  end

  class StackUnderflowError < StandardError
  end

  class InstructionUnknownError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  class ExceedingAllowableMemoryError < StandardError
    def initialize
      super('ROM you are trying to load is too big')
    end
  end
end
