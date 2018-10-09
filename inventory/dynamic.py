#!/usr/bin/python

import re
import socket

host = socket.gethostname()

if host == 'WUSFH185036-L8Q':
    group = 'work'
elif re.match(r'fdh-mbp(?:\.(?:local|lan)?)?\Z', host):
    group = 'personal'
elif re.match(r'dev(?:vm)?\d+', host):
    group = 'devservers'
else:
    group = 'local'

print """
{
  "%s": {
    "hosts": [
      "localhost"
    ],
    "vars": {
      "ansible_connection": "local"
    }
  }
}
""" % group
