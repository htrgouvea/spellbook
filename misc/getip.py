#!/usr/bin/env python
# Usage: python getip.py target.com

import sys
import socket

def getip(hostname):
    if (hostname):  
        try:
            ip = socket.gethostbyname(hostname)
            print ip
        except:
            return 0
    return 0

getip(sys.argv[1])