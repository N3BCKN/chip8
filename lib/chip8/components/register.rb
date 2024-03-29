# frozen_string_literal: true

module Chip8
  class Register
    attr_accessor :delay_timer, :sound_timer, :sp, :pc, :stack, :v, :i

    def initialize
      @v = Array.new(NUMBER_OF_REGISTERS, 0)
      @i = 0
      @delay_timer = 0
      @sound_timer = 0
      @sp = -1 # stack_pointer
      @pc = LOAD_PROGRAM_ADDRESS # program counter
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
      raise StackOverflowError if stack_overflow?

      @stack[@sp] = value
    end

    def pop_stack
      value = @stack[@sp]
      @sp -= 1
      raise StackUnderflowError if stack_underflow?

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
