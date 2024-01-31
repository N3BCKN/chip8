# frozen_string_literal: true

require 'ruby2d'

require_relative './lib/chip8'

set width:   Chip8::BASE_WIDTH  * Chip8::SCREEN_MULTIPLIER
set height:  Chip8::BASE_HEIGHT * Chip8::SCREEN_MULTIPLIER
set color:   Chip8::BG_COLOR
set title:   Chip8::TITLE
set fps_cap: Chip8::FPS_NUMBER

memory   = Chip8::Memory.new
register = Chip8::Register.new
keyboard = Chip8::Keyboard.new
screen   = Chip8::Screen.new(memory)
sound    = Chip8::SoundCard.new

memory.load_sprites

on :key_down do |event|
  keyboard.key_down(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

on :key_up do |event|
  keyboard.key_down(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

update do
  clear

  if register.delay_timer > 0
    sleep Chip8::TIMER_60_HZ
    register.delay_timer -= 1
  end

  if register.sound_timer > 0
    sound.play
    sleep Chip8::TIMER_60_HZ
    register.sound_timer -= 1
  end

  sound.stop if register.sound_timer == 0



  screen.draw_buffer
  screen.draw_sprite(10, 1,  0, 5)
  screen.draw_sprite(10, 6,  5, 5)
  screen.draw_sprite(10, 11, 10, 5)
  screen.draw_sprite(10, 16, 15, 5)
end

show
