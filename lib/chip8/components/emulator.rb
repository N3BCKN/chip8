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
      @register.pc += 2

      disassambled = @disassambler.disassamble(opcode)
      id           = disassambled[:instruction][:id]
      args         = disassambled[:arguments]

      case id
      when :cls
        @screen.reset_buffer
      when :ret
        @register.pc = @register.pop_stack
      when :jp_addr
        @register.pc = args[0]
      when :call_addr
        @register.push_stack(@register.pc)
        @register.pc = args[0]
      when :se_vx_kk
        @register.pc += 2 if @register.v[args[0]] == args[1]
      when :sne_vx_kk
        @register.pc += 2 if @register.v[args[0]] != args[1]
      when :se_vx_vy
        @register.pc += 2 if @register.v[args[0]] == @register.v[args[1]]
      when :ld_vx_kk
        @register.v[args[0]] = args[1]
      when :add_vx_kk
        @register.v[args[0]] += args[1]
        @register.v[args[0]] &= 0xff
      when :ld_vx_vy
        @register.v[args[0]] = @register.v[args[1]]
      when :or_vx_vy
        @register.v[args[0]] |= @register.v[args[1]]
      when :and_vx_vy
        @register.v[args[0]] &= @register.v[args[1]]
      when :xor_vx_vy
        @register.v[args[0]] ^= @register.v[args[1]]
      when :add_vx_vy
        @register.v[0x0f] = if @register.v[args[0]] + @register.v[args[1]] > 0xff
                              1
                            else
                              0
                            end
        @register.v[args[0]] += @register.v[args[1]]
      when :sub_vx_vy
        @register.v[0x0f] = if @register.v[args[0]] > @register.v[args[1]]
                              1
                            else
                              0
                            end
        @register.v[args[0]] -= @register.v[args[1]]
      when :shr_vx_vy
        @register.v[0x0f] = @register.v[args[0]] & 0x01
        @register.v[args[0]] >>= 1
      when :subn_vx_vy
        @register.v[0x0f] = @register.v[args[1]] > @register.v[args[0]] ? 1 : 0
        @register.v[args[0]] = @register.v[args[1]] - @register.v[args[0]]
      when :shl_vx_vy
        @register.v[0x0f] = @register.v[args[0]] & 0x80 > 0 ? 1 : 0
        @register.v[args[0]] <<= 1
      when :sne_vx_vy
        @register.pc += 2 if @register.v[args[0]] != @register.v[args[1]]
      when :ld_i_addr
        @register.i = args[0]
      when :jp_v0_addr
        @register.pc = @register.v[0] + args[0]
      when :rnd_vx_kk
        random = (rand * 0xff).floor
        @register.v[args[0]] = random & args[1]
      when :drw_vx_vy_n
        collision = screen.draw_sprite(
          @register.v[args[1]],
          @register.v[args[0]],
          @register.i,
          args[2]
        )

        @register.v[0x0f] = collision
      when :skp_vx
        @register.pc += 2 if @keyboard.key_down?(@register.v[args[0]])
      when :sknp_vx
        @register.pc += 2 unless @keyboard.key_down?(@register.v[args[0]])
      when :ld_vx_dt
        @register.v[args[0]] = @register.delay_timer
      when :ld_vx_k
        Thread.new do
          key_pressed = @keyboard.any_key_down?
          loop do
            break if key_pressed

            key_pressed = @keyboard.any_key_down?
            sleep 0.1
          end
          @register.v[args[0]] = key_pressed
        end
      when :ld_dt_vx
        @register.delay_timer = @register.v[args[0]]
      when :ld_st_vx
        @register.sound_timer = @register.v[args[0]]
      when :add_i_vx
        @register.i += @register.v[args[0]]
      when :ld_f_vx
        @register.i = @register.v[args[0]] * SPRITE_HIGHT
      when :ld_b_vx
        x        = register.v[args[0]]
        hundreds = (x / 100).floor
        tens     = ((x - hundreds * 100) / 10).floor
        ones     = ((x - hundreds * 100) - tens * 10).floor
        @memory[@register.i]     = hundreds
        @memory[@register.i + 1] = tens
        @memory[@register.i + 2] = ones
      when :ld_i_vx
        (0..args[0]).each do |n|
          @memory[@register.i + n] = @register.v[n]
        end
      when :ld_vx_i
        (0..args[0]).each do |n|
          @register.v[n] = @memory[@register.i + n]
        end
      end
    end
  end
end
