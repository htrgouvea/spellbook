#!/usr/bin/env python
# Usage: python resolv.py target.com

import sys
import socket

def resolv(hostname):
    if (hostname):  
        try:
            ip = socket.gethostbyname_ex(hostname)
            print hostname
        except:
            return 0
    return 0

resolv(sys.argv[1])