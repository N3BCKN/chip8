# frozen_string_literal: true

module Chip8
  class Keyboard
    attr_reader :keys

    def initialize
      @keys = {
        '1': false, '2': false, '3': false, '4': false,
        q: false, w: false, e: false, r: false,
        a: false, s: false, d: false, f: false,
        z: false, x: false, c: false, v: false
      }
    end

    def key_down(key)
      @keys[key] = true
    end

    def key_up(key)
      @keys[key] = false
    end

    def key_down?(key_code)
      @keys.values[key_code]
    end

    def any_key_down?
      @keys.value?(true) ? @keys.values.find_index(true) : false
    end
  end
end
