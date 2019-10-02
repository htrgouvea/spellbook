#!/usr/bin/env ruby

require 'base32'

string = ARGV[0]
decoded_string = Base32.decode(string)

puts decoded_string
exit
