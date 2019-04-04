#!/usr/bin/env python

import re
import sys

for line in sys.stdin:
  val = line.strip()
  (month, temp, q) = (val[19:21], val[87:92], val[92:93])
  if (temp != "+9999" and re.match("[01459]", q)):
    print "%s\t%s\t%s" % (month, 1, 1)
  elif (temp != "+9999" and re.match("[01459]", q)):
    print "%s\t%s\t%s" % (month, 1, 0)
  elif (temp == "+9999" and re.match("[01459]", q)):
    print "%s\t%s\t%s" % (month, 0, 1)
  else:
    print "%s\t%s\t%s" % (month, 0, 0)
    
    
