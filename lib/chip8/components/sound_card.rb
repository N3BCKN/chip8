# frozen_string_literal: true

module Chip8
  class SoundCard
    def initialize
      @beep = Music.new('assets/sounds/beep.wav')
      @beep.loop = true
    end

    def play
      @beep.play
    end

    def stop
      @beep.stop
    end
  end
end
