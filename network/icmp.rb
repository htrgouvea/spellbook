#!/usr/bin/env ruby

require 'net/ping'

target = ARGV[0]

def up?(host)
    check = Net::Ping::External.new(host)
    check.ping?
end

response = up?(target)

puts "#{target} -> #{response}"
exit