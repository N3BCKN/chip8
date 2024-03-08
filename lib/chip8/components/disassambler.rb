# frozen_string_literal: true

module Chip8
  class Disassambler
    def disassamble(opcode)
      instruction = INSTRUCTIONS.detect { |instruction| (opcode & instruction[:mask]) == instruction[:pattern] }
      arguments = instruction[:arguments].map do |arg|
        if arg.has_key? :shift
          arg[:mask] & opcode >> arg[:shift]
        else
          arg[:mask] & opcode
        end
      end 

      {instruction: instruction, arguments: arguments}
    end
  end
end
