#!/usr/bin/ruby

require 'net/ping'

def main
  if ARGV[0]
    	@icmp = Net::Ping::ICMP.new(ARGV[0])
      if @icmp.ping
        puts "#{ARGV[0]}"
      else

      end
  end
end

main()
exit
