# frozen_string_literal: true

require 'ruby2d'

require_relative './lib/chip8'

set width: BASE_WIDTH * SCREEN_MULTIPLIER
set height: BASE_HEIGHT * SCREEN_MULTIPLIER
set color: BG_COLOR
set title: TITLE
set fps_cap: FPS_NUMBER

screen   = Screen.new
memory   = Memory.new
register = Register.new

update do
  clear

  screen.draw_buffer
  screen.reset_buffer
end

show
