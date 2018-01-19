#!/usr/bin/ruby

#
# Use: ./base32.rb
# Heitor Gouvêa - hi@heitorgouvea.me

require 'base32'

def main
  if ARGV[0]
    $decryptBase32 = Base32.decode(ARGV[0])

    puts $decryptBase32
  end
end

main()
exit
