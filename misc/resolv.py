#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import socket

hostname = sys.argv[1]
ip = socket.gethostbyname(hostname)

print ip