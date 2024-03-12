# frozen_string_literal: true

module Chip8
  class Emulator
    attr_accessor :keyboard, :screen, :register, :sound

    def initialize
      @memory   = Memory.new
      @register = Register.new
      @keyboard = Keyboard.new
      @screen   = Screen.new(@memory)
      @sound    = SoundCard.new
      @disassambler = Disassambler.new
    end

    def run
      load_sprites_to_memory(SPRITES)
      rom = open_rom
      load_rom_to_memory(rom)
    end

    private

    def open_rom
      path = ARGV[0] || './roms/test_opcode.ch8' #  TODO: custom error class here

      (File.open(path, 'rb') { |f| f.read }).unpack('C*')
    end

    def load_sprites_to_memory(sprites)
      sprites.each_with_index { |v, i| @memory[i] = v }
    end

    def load_rom_to_memory(rom)
      return unless rom.size + LOAD_PROGRAM_ADDRESS <= MEMORY_SIZE # TODO: custom error class here

      rom.each_with_index { |v, i| @memory[LOAD_PROGRAM_ADDRESS + i] = v }
    end

    def execute(opcode)
      disassambled = @disassambler.disassamble(opcode)

      case disassambled[:instruction][:id]
      when 'CLS'
        @screen.reset_buffer
      end
    end
  end
end
