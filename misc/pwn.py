#!/usr/bin/env python

import sys, socket

ip = sys.argv[1]
porta = int(sys.argv[2])

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
response = s.connect_ex((ip, porta))

if (response == 0):
    print ip, porta
else:
    print "error"