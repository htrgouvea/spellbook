#!/usr/bin/env python
# Usage: python resolv.py target.com

import sys
import socket

def resolv(hostname):
    if (hostname):
        ip = socket.gethostbyname(hostname)
        
        try:
            return hostname
        except:
            return 0
    return 0

print resolv(sys.argv[1])