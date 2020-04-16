#!/usr/bin/env python
# Usage: python gen_favicon_hash.py https://target.com

import sys
import mmh3
import requests
 
def genHash(target):
    if (target):
        target   = sys.argv[1]
        response = requests.get(target)
        
        try:
            favicon  = response.content.encode('base64')
            hash     = mmh3.hash(favicon)

            return hash
        except:
            return 0
    return 0

print genHash(sys.argv[1])