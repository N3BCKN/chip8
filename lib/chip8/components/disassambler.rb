# frozen_string_literal: true

module Chip8
  class Disassambler
    def self.disassamble(opcode)
      instruction = INSTRUCTIONS.detect { |instruction| (opcode & instruction[:mask]) == instruction[:pattern] }
      arguments = instruction[:arguments].map { |arg| arg[:mask] & opcode >> arg[:shift] }
    end
  end
end
