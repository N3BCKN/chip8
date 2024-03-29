# frozen_string_literal: true

require 'optparse'

class Parser
  def self.parse
    args = { rom_address: nil, debug: false }

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: ruby chip8 [options]'
      opts.on('-r [String]', '--rom [String]', 'Point address to the ROM you want to load') do |addr|
        args[:rom_address] = addr
      end
      opts.on('-d', '--debug', 'run in debug mode') do
        args[:debug] = true
      end
      opts.on('-v', '--version', 'Display the version') do
        puts Chip8::VERSION
        exit
      end
      opts.on('-h', '--help', 'Display this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!
    args
  end
end
