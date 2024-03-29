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

      load_sprites_to_memory(SPRITES)
      rom = open_rom
      load_rom_to_memory(rom)
    end

    def run
      opcode = @memory.opcode(@register.pc)
      execute(opcode)
    end

    private

    def open_rom
      path = ARGV[0] || './roms/br8kout.ch8' #  TODO: custom error class here

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
      @register.pc += 2

      disassambled = @disassambler.disassamble(opcode)
      id           = disassambled[:instruction][:id]
      args         = disassambled[:arguments]

      case id
      when 'CLS'
        @screen.reset_buffer
      when 'RET'
        @register.pc = @register.pop_stack
      when 'JP_ADDR'
        @register.pc = args[0]
      when 'CALL_ADDR'
        @register.push_stack(@register.pc)
        @register.pc = args[0]
      when 'SE_VX_KK'
        @register.pc += 2 if @register.v[args[0]] == args[1]
      when 'SNE_VX_KK'
        @register.pc += 2 if @register.v[args[0]] != args[1]
      when 'SE_VX_VY'
        @register.pc += 2 if @register.v[args[0]] == @register.v[args[1]]
      when 'LD_VX_KK'
        @register.v[args[0]] = args[1]
      when 'ADD_VX_KK'
        @register.v[args[0]] += args[1]
        @register.v[args[0]] &= 0xff
      when 'LD_VX_VY'
        @register.v[args[0]] = @register.v[args[1]]
      when 'OR_VX_VY'
        @register.v[args[0]] |= @register.v[args[1]]
      when 'AND_VX_VY'
        @register.v[args[0]] &= @register.v[args[1]]
      when 'XOR_VX_VY'
        @register.v[args[0]] ^= @register.v[args[1]]
      when 'ADD_VX_VY'
        @register.v[0x0f] = if @register.v[args[0]] + @register.v[args[1]] > 0xff
                              1
                            else
                              0
                            end
        @register.v[args[0]] += @register.v[args[1]]
      when 'SUB_VX_VY'
        @register.v[0x0f] = if @register.v[args[0]] > @register.v[args[1]]
                              1
                            else
                              0
                            end
        @register.v[args[0]] -= @register.v[args[1]]
      when 'SHR_VX_VY'
        @register.v[0x0f] = @register.v[args[0]] & 0x01
        @register.v[args[0]] >>= 1
      when 'SUBN_VX_VY'
        @register.v[0x0f] = @register.v[args[1]] > @register.v[args[0]] ? 1 : 0
        @register.v[args[0]] = @register.v[args[1]] - @register.v[args[0]]
      when 'SHL_VX_VY'
        @register.v[0x0f] = @register.v[args[0]] & 0x80 > 0 ? 1 : 0
        @register.v[args[0]] <<= 1
      when 'SNE_VX_VY'
        @register.pc += 2 if @register.v[args[0]] != @register.v[args[1]]
      when 'LD_I_ADDR'
        @register.i = args[0]
      when 'JP_V0_ADDR'
        @register.pc = @register.v[0] + args[0]
      when 'RND_VX_KK'
        random = (rand * 0xff).floor
        @register.v[args[0]] = random & args[1]
      when 'DRW_VX_VY_N'
        collision = screen.draw_sprite(
          @register.v[args[1]],
          @register.v[args[0]],
          @register.i,
          args[2]
        )

        @register.v[0x0f] = collision
      when 'SKP_VX'
        @register.pc += 2 if @keyboard.key_down?(@register.v[args[0]])
      when 'SKNP_VX'
        @register.pc += 2 unless @keyboard.key_down?(@register.v[args[0]])
      when 'LD_VX_DT'
        @register.v[args[0]] = @register.delay_timer
      when 'LD_VX_K'
        Thread.new do
          key_pressed = @keyboard.any_key_down?
          loop do
            break if key_pressed

            key_pressed = @keyboard.any_key_down?
            sleep 0.1
          end
          @register.v[args[0]] = key_pressed
        end
      when 'LD_DT_VX'
        @register.delay_timer = @register.v[args[0]]
      when 'LD_ST_VX'
        @register.sound_timer = @register.v[args[0]]
      when 'ADD_I_VX'
        @register.i += @register.v[args[0]]
      when 'LD_F_VX'
        @register.i = @register.v[args[0]] * SPRITE_HIGHT
      when 'LD_B_VX'
        x        = register.v[args[0]]
        hundreds = (x / 100).floor
        tens     = ((x - hundreds * 100) / 10).floor
        ones     = ((x - hundreds * 100) - tens * 10).floor
        @memory[@register.i]     = hundreds
        @memory[@register.i + 1] = tens
        @memory[@register.i + 2] = ones
      when 'LD_I_VX'
        (0..args[0]).each do |n|
          @memory[@register.i + n] = @register.v[n]
        end
      when 'LD_VX_I'
        (0..args[0]).each do |n|
          @register.v[n] = @memory[@register.i + n]
        end
      end
    end
  end
end
