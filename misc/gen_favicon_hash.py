#!/usr/bin/env python

import mmh3
import requests
 
response = requests.get('https://target.com/favicon.ico')
favicon = response.content.encode('base64')
hash = mmh3.hash(favicon)

print hash

exit