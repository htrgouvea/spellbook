#!/usr/bin/ruby

#
# Use: ./hex.rb
# Heitor Gouvêa - hi@heitorgouvea.me

require 'hex_string'

def main
  if ARGV[0]
    	$decoderHex = ARGV[0].to_byte_string

      puts $decoderHex
  end
end

main()
exit
