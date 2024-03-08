# frozen_string_literal: true

module Chip8
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
  LOAD_PROGRAM_ADDRESS = 0x200
  CHARSET_ADDRESS = 0x000

  # register
  NUMBER_OF_REGISTERS = 16
  STACK_DEPTH = 16
  TIMER_60_HZ = 1 / 60

  # keyboard
  NUMBER_OF_KEYS = 16
  ACCEPTED_KEYS = %w[
    1 2 3 4
    q w e r
    a s d f
    z x c v
  ].freeze
  KEYBOARD_MAPPER = {}.freeze

  # sprites
  SPRITES = [
    0xF0, 0x90, 0x90, 0x90, 0xF0, # 0
    0x20, 0x60, 0x20, 0x20, 0x70, # 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, # 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, # 3
    0x90, 0x90, 0xF0, 0x10, 0x10, # 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, # 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, # 6
    0xF0, 0x10, 0x20, 0x40, 0x40, # 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, # 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, # 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, # A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, # B
    0xF0, 0x80, 0x80, 0x80, 0xF0, # C
    0xE0, 0x90, 0x90, 0x90, 0xE0, # D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, # E
    0xF0, 0x80, 0xF0, 0x80, 0x80  # F
  ].freeze

  # CPU instructions
  MASK_NNN = { mask: 0x0fff }
  MASK_N   = { mask: 0x000f  }
  MASK_VX  = { mask: 0x0f00, shift: 8 }
  MASK_VY  = { mask: 0x00f0, shift: 4 }
  MASK_KK  = { mask: 0x00ff }

  INSTRUCTIONS = [
    {
      key: 2,
      id: 'CLS',
      name: 'CLS',
      mask: 0xffff,
      pattern: 0x00e0,
      arguments: []
    },
    {
      key: 3,
      id: 'RET',
      name: 'RET',
      mask: 0xffff,
      pattern: 0x00ee,
      arguments: []
    },
    {
      key: 4,
      id: 'JP_ADDR',
      name: 'JP',
      mask: 0xf000,
      pattern: 0x1000,
      arguments: [MASK_NNN]
    },
    {
      key: 5,
      id: 'CALL_ADDR',
      name: 'CALL',
      mask: 0xf000,
      pattern: 0x2000,
      arguments: [MASK_NNN]
    },
    {
      key: 6,
      id: 'SE_VX_KK',
      name: 'SE',
      mask: 0xf000,
      pattern: 0x3000,
      arguments: [MASK_VX, MASK_KK]
    },
    {
      key: 7,
      id: 'SNE_VX_NN',
      name: 'SNE',
      mask: 0xf000,
      pattern: 0x4000,
      arguments: [MASK_VX, MASK_KK]
    },
    {
      key: 8,
      id: 'SE_VX_VY',
      name: 'SE',
      mask: 0xf00f,
      pattern: 0x5000,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 9,
      id: 'LD_VX_KK',
      name: 'LD',
      mask: 0xf000,
      pattern: 0x6000,
      arguments: [MASK_VX, MASK_KK]
    },
    {
      key: 10,
      id: 'ADD_VX_KK',
      name: 'ADD',
      mask: 0xf000,
      pattern: 0x7000,
      arguments: [MASK_VX, MASK_KK]
    },
    {
      key: 11,
      id: 'LD_VX_VY',
      name: 'LD',
      mask: 0xf00f,
      pattern: 0x8000,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 12,
      id: 'OR_VX_VY',
      name: 'OR',
      mask: 0xf00f,
      pattern: 0x8001,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 13,
      id: 'AND_VX_VY',
      name: 'AND',
      mask: 0xf00f,
      pattern: 0x8002,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 14,
      id: 'XOR_VX_VY',
      name: 'XOR',
      mask: 0xf00f,
      pattern: 0x8003,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 15,
      id: 'ADD_VX_VY',
      name: 'ADD',
      mask: 0xf00f,
      pattern: 0x8004,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 16,
      id: 'SUB_VX_VY',
      name: 'SUB',
      mask: 0xf00f,
      pattern: 0x8005,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 17,
      id: 'SHR_VX_VY',
      name: 'SHR',
      mask: 0xf00f,
      pattern: 0x8006,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 18,
      id: 'SUBN_VX_VY',
      name: 'SUBN',
      mask: 0xf00f,
      pattern: 0x8007,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 19,
      id: 'SHL_VX_VY',
      name: 'SHL',
      mask: 0xf00f,
      pattern: 0x800E,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 20,
      id: 'SNE_VX_VY',
      name: 'SNE',
      mask: 0xf00f,
      pattern: 0x9000,
      arguments: [MASK_VX, MASK_VY]
    },
    {
      key: 21,
      id: 'LD_I_ADDR',
      name: 'LD',
      mask: 0xf000,
      pattern: 0xa000,
      arguments: [MASK_NNN]
    },
    {
      key: 22,
      id: 'JP_V0_ADDR',
      name: 'JP',
      mask: 0xf000,
      pattern: 0xb000,
      arguments: [MASK_NNN]
    },
    {
      key: 23,
      id: 'RND_VX',
      name: 'RND',
      mask: 0xf000,
      pattern: 0xc000,
      arguments: [MASK_VX, MASK_KK]
    },
    {
      key: 24,
      id: 'DRW_VX_VY_N',
      name: 'DRW',
      mask: 0xf000,
      pattern: 0xd000,
      arguments: [MASK_VX, MASK_VY, MASK_N]
    },
    {
      key: 25,
      id: 'SKP_VX',
      name: 'SKP',
      mask: 0xf0ff,
      pattern: 0xe09e,
      arguments: [MASK_VX]
    },
    {
      key: 26,
      id: 'SKNP_VX',
      name: 'SKNP',
      mask: 0xf0ff,
      pattern: 0xe0a1,
      arguments: [MASK_VX]
    },
    {
      key: 27,
      id: 'LD_VX_DT',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf007,
      arguments: [MASK_VX]
    },
    {
      key: 28,
      id: 'LD_VX_K',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf00a,
      arguments: [MASK_VX]
    },
    {
      key: 29,
      id: 'LD_DT_VX',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf015,
      arguments: [MASK_VX]
    },
    {
      key: 30,
      id: 'LD_ST_VX',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf018,
      arguments: [MASK_VX]
    },
    {
      key: 31,
      id: 'ADD_I_VX',
      name: 'ADD',
      mask: 0xf0ff,
      pattern: 0xf01e,
      arguments: [MASK_VX]
    },
    {
      key: 32,
      id: 'LD_F_VX',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf029,
      arguments: [MASK_VX]
    },
    {
      key: 33,
      id: 'LD_B_VX',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf033,
      arguments: [MASK_VX]
    },
    {
      key: 34,
      id: 'LD_I_VX',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf055,
      arguments: [MASK_VX]
    },
    {
      key: 35,
      id: 'LD_VX_I',
      name: 'LD',
      mask: 0xf0ff,
      pattern: 0xf065,
      arguments: [MASK_VX]
    }
  ].freeze
end
