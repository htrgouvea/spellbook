#!/usr/bin/env ruby

require 'json'
require 'rest-client'

def main
    target = ARGV[0]

    if target
        request = RestClient.get "#{target}/wp-json/wp/v2/users/"

        if request.code == 200
            parse = JSON.parse(request.body)
            
            parse.each do |parsing|
                puts "[ ! ] Username -> #{parsing['slug']}\n"
            end
        end
    end
end

main
exit
