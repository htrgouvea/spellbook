#!/usr/bin/ruby

#
# Use: ./morse.rb
# Heitor Gouvêa - hi@heitorgouvea.me

require 'morse'

def main
  if ARGV[0]
    $decodeMorse = Morse.decode(ARGV[0])

    puts $decodeMorse
  end
end

main()
exit
