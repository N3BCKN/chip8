# frozen_string_literal: true

module Chip8
  class Debugger
    def initialize
      @start_time = Time.now
    end

    def print_message(cycle, id, args, opcode, sp, pc, i, v)
      p "execution time: #{Time.now - @start_time} sec"
      p "cycle: #{cycle}"
      p "instruction: #{id}"
      p "arguments: #{args}"
      p "opcode: #{opcode}"
      p "stack_pointer: #{sp}"
      p "program counter: #{pc}"
      p "i: #{i}"
      p "v: #{v}"
      p '---' * 10
    end
  end
end
