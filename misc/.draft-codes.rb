#!/usr/bin/env ruby

def reverseString
    string = ARGV[0]
    puts string.reverse
end

def base64Decode
    require 'base64'

    string = ARGV[0]
    decoded_string = Base64.decode64(string)

    puts decoded_string
end

def base32Decode
    require 'base32'

    string = ARGV[0]
    decoded_string = Base32.decode(string)

    puts decoded_string
end