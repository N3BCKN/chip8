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

memory.load_sprites
screen.draw_buffer
screen.draw_sprite(1, 10,  0, 5)
screen.draw_sprite(6, 10,  5, 5)
screen.draw_sprite(11, 10, 10, 5)
screen.draw_sprite(16, 10, 15, 5)

on :key_down do |event|
  keyboard.key_down(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

on :key_up do |event|
  keyboard.key_down(event.key.to_sym) if Chip8::ACCEPTED_KEYS.include? event.key
end

# update do
#   clear

#   screen.draw_buffer
#   screen.reset_buffer
# end

show
