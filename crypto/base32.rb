#!/usr/bin/ruby

require 'base32'

def main
  if ARGV[0]
    print Base32.decode(ARGV[0])
  end
end

main()
exit
