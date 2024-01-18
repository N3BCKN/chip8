# frozen_string_literal: true

# main
TITLE = 'chip8 emulator'
FPS_NUMBER = 30

# display
BASE_WIDTH  = 64
BASE_HEIGHT = 32
SCREEN_MULTIPLIER = 10
BG_COLOR = '#000000'
COLOR = '#33ff66'

# memory
MEMORY_SIZE = 4095
LOAD_PROGRAM_ADRRESS = 0x200

# register
NUMBER_OF_REGISTERS = 16
STACK_DEPTH = 16

# keyboard
NUMBER_OF_KEYS = 16
ACCEPTED_KEYS = [
  '1','2','3','4',
  'q','w','e','r',
  'a','s','d','f',
  'z','x','c','v'
].freeze
KEYBOARD_MAPPER = {}.freeze
