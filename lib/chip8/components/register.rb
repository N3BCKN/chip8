# frozen_string_literal: true

module Chip8
  class Register
    attr_accessor :delay_timer, :sound_timer, :stack_pointer, :program_counter, :stack, :v, :i

    def initialize
      @v = Array.new(NUMBER_OF_REGISTERS, 0)
      @i = 0
      @delay_timer = 0
      @sound_timer = 0
      @stack_pointer = -1
      @program_counter = LOAD_PROGRAM_ADDRESS
      @stack = Array.new(STACK_DEPTH, 0)
    end

    def reset
      @v.fill(0)
      @stack.fill(0)
      @i = 0
      @delay_timer = 0
      @sound_timer = 0
      @stack_pointer = -1
      @program_counter = LOAD_PROGRAM_ADDRESS
    end

    def push_stack(value)
      @stack_pointer += 1
      raise StandardError if stack_overflow? # TODO: write custom error class to handle it

      @stack[@stack_pointer] = value
    end

    def pop_stack
      value = @stack[@stack_pointer]
      @stack_pointer -= 1
      raise StandardError if stack_underflow? # TODO: write custom error class to handle it

      value
    end

    private

    def stack_overflow?
      @stack_pointer >= STACK_DEPTH
    end

    def stack_underflow?
      @stack_pointer < -1
    end
  end
end
