#!/usr/bin/env ruby

require 'rest-client'

target   = ARGV[0]
wordlist = ARGV[1]

if target && wordlist
    verbs = [
        "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "CONNECT", "TRACE", "PATCH", "SUBSCRIBE", "MOVE", "REPORT",
        "UNLOCK", "0", "%s%s%s%s", "PURGE", "POLL", "OPTIONS", "NOTIFY", "SEARCH", "1337", "JEFF", "CATS", "*"
    ]

    verbs.each do |verb|
        request = RestClient::Request.new(
            :method     => verb,
            :url        => target,
            :verify_ssl => true
        ).execute
    
        puts request
    end
end
