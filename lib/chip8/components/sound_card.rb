# frozen_string_literal: true

module Chip8
  class SoundCard
    def initialize
      @beep = Sound.new('assets/sounds/beep.wav')
    end

    def play
      @beep.play
    end
  end
end
