#!/usr/bin/env ruby

require 'base64'

string = ARGV[0]
decoded_string = Base64.decode64(string)

puts decoded_string
exit
