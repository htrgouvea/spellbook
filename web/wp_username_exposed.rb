#!/usr/bin/env ruby

require 'json'
require 'rest-client'

def main
    target = ARGV[0]

    if target 
        request = RestClient::Request.new(
            :method     => :get,
            :url        => target + '/wp-json/wp/v2/users/',
            :verify_ssl => false
        ).execute

        parse = JSON.parse(request.body)
        
        parse.each do |parsing|
            puts "[ ! ] Username -> #{parsing['slug']}\n"
        end
    end
end

main
exit
