#!/usr/bin/env python

import sys

(last_key, min_val) = (None, sys.maxint)
for line in sys.stdin:
  (key, val) = line.strip().split("\t")
  (key, val) = (key, float(val)/10)
  if last_key and last_key != key:
    print "%s\t%s" % (last_key, min_val)
    (last_key, min_val) = (key, float(val))
  else:
    (last_key, min_val) = (key, min(min_val, float(val)))

if last_key:
  print "%s\t%s" % (last_key, min_val)
