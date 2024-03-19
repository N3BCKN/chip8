# frozen_string_literal: true

require 'ruby2d'

require_relative './lib/chip8'

set width:   Chip8::BASE_WIDTH  * Chip8::SCREEN_MULTIPLIER
set height:  Chip8::BASE_HEIGHT * Chip8::SCREEN_MULTIPLIER
set color:   Chip8::BG_COLOR
set title:   Chip8::TITLE
set fps_cap: Chip8::FPS_NUMBER

chip8 = Chip8::Emulator.new
chip8.run

on :key_down do |event|
  chip8.keyboard.key_down(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

on :key_up do |event|
  chip8.keyboard.key_up(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

# chip8.screen.draw_sprite(10, 1,  0, 5)
# chip8.screen.draw_sprite(10, 6,  5, 5)
# chip8.screen.draw_sprite(10, 11, 10, 5)
# chip8.screen.draw_sprite(10, 16, 15, 5)

update do
  clear

  chip8.run

  if chip8.register.delay_timer > 0
    sleep Chip8::TIMER_60_HZ
    chip8.register.delay_timer -= 1
  end

  if chip8.register.sound_timer > 0
    chip8.sound.play
    sleep Chip8::TIMER_60_HZ
    chip8.register.sound_timer -= 1
  end

  chip8.sound.stop if chip8.register.sound_timer == 0

  chip8.screen.draw_buffer
end

show
