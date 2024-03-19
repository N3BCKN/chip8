# frozen_string_literal: true

module Chip8
  class Register
    attr_accessor :delay_timer, :sound_timer, :sp, :pc, :stack, :v, :i

    def initialize
      @v = Array.new(NUMBER_OF_REGISTERS, 0)
      @i = 0
      @delay_timer = 0
      @sound_timer = 0
      @sp = -1 # sp
      @pc = LOAD_PROGRAM_ADDRESS
      @stack = Array.new(STACK_DEPTH, 0)
    end

    def reset
      @v.fill(0)
      @stack.fill(0)
      @i = 0
      @delay_timer = 0
      @sound_timer = 0
      @sp = -1
      @pc = LOAD_PROGRAM_ADDRESS
    end

    def push_stack(value)
      @sp += 1
      raise StandardError if stack_overflow? # TODO: write custom error class to handle it

      @stack[@sp] = value
    end

    def pop_stack
      value = @stack[@sp]
      @sp -= 1
      raise StandardError if stack_underflow? # TODO: write custom error class to handle it

      value
    end

    private

    def stack_overflow?
      @sp >= STACK_DEPTH
    end

    def stack_underflow?
      @sp < -1
    end
  end
end
