#!/usr/bin/ruby

#
# Use: ./base64.rb
# Heitor Gouvêa - hi@heitorgouvea.me

require 'base64'

def main
  if ARGV[0]
    $decryptBase64 = Base64.decode64(ARGV[0])

    puts $decryptBase64
  end
end

main()
exit
