#!/usr/bin/ruby

require 'base64'

def main
  if ARGV[0]
    print Base64.decode(ARGV[0])
  end
end

main()
exit
